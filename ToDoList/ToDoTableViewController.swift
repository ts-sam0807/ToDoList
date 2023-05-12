//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Ts SaM on 12/5/2023.
//

import UIKit

class ToDoTableViewController: UITableViewController {
  
  var todos = [ToDo]()
  
  
  
  
  @IBAction func unwindToDoList(segue: UIStoryboardSegue) {
    guard segue.identifier == "saveUnwind" else { return }
    let sourceViewController = segue.source as! ToDoDetailTableViewController
    
    if let todo = sourceViewController.todo {
      if let indexOfExistingToDo = todos.firstIndex(of: todo) {
        todos[indexOfExistingToDo] = todo
        tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
      } else {
        let newIndexPath = IndexPath(row: todos.count, section: 0)
        todos.append(todo)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    if let savedToDos = ToDo.loadToDos() {
      todos = savedToDos
    } else {
      todos = ToDo.loadSampleToDos()
    }
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell
    let todo = todos[indexPath.row]
    cell.textLabel?.text = todo.title
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      todos.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
    guard let cell = sender as? UITableViewCell,
          let indexPath = tableView.indexPath(for: cell) else {
      return nil
    }
    tableView.deselectRow(at: indexPath, animated: true)
    let detailController = ToDoDetailTableViewController(coder: coder)
    detailController?.todo = todos[indexPath.row]
    return detailController
  }
  
  
  
  
}
