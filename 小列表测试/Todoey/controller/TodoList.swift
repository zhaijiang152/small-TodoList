import UIKit

class TodoListviewcontroller: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
//——————————————————————————————————————————————————————————————————————————————————————
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }//配置单元格包
    
    //——————————————————————————————————————————————————————————————————————————
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //要显示某一行时触发⬆️
        
        // 从重用池中获取一个可重用的单元格，使用标识符 "TodoItemcell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemcell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // 设置单元格的文本标签（textLabel）为 itemArray 数组中对应行的数据
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        // 返回配置好的单元格
        return cell
    }
    //———————————————————————————————————————————————————————————————————————————————
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击列表中某一行时触发⬆️
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItem() //保存列表
        
        // 取消选中单元格，保持单元格在点击后不再保持选中状态
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //—————————————————————————————————————————————————————————————————————————————
    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "是否添加列表", message: "区分一下", preferredStyle: .alert)
        //使用UIAlertAction添加一个点击行为
        let action = UIAlertAction(title: "添加", style: .default) { [self] (action) in
            let newItem = Item()
            newItem.title = textField.text!
            //用户点击我们的 UIAlert 中的添加项按钮后会发生什么
            self.itemArray.append(newItem)//添加表格内容到数组中
            self.saveItem() //保存列表
        }
        
        // 在 UIAlertController 中添加一个文本输入框
        alert.addTextField { (alertTextField) in
            // 设置文本框的占位符文本
            alertTextField.placeholder = "创建新的表格单元"
            // 将创建的文本框保存到 textField 变量中
            textField = alertTextField
        }
        alert.addAction(action) //使用addAction将点击行为添加到弹窗中
        present(alert, animated: true, completion: nil) //控制弹窗动画
        
    }
    //————————————————————————————————————————————————————————————————————————
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("列表编码错误,\(error)")
        }
        self.tableView.reloadData()  //刷新视图,用于呈现新的内容
    }
    //-------------------------————————————————————————————————————————————————
    func loadItems(){
        if  let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("解码错误，\(error)")
            }
        }
        
    }
//————————————————————————————————————————————————————————————————————————
}
