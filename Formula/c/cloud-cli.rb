#!/usr/bin/env ruby

# cloud - A tool for managing multi-service projects
# Author: https://github.com/this-is-allan
# Version: 1.0.0

require 'json'
require 'fileutils'

# Configuration
CONFIG_DIR = File.join(ENV['HOME'], '.cloud')
CONFIG_FILE = File.join(CONFIG_DIR, 'config.json')

# Check dependencies
def check_dependencies
  missing_deps = []
  
  missing_deps << "tmux" unless system("which tmux > /dev/null 2>&1")
  
  unless missing_deps.empty?
    puts "Error: Missing dependencies: #{missing_deps.join(', ')}"
    puts "Please install them using:"
    puts "  brew install #{missing_deps.join(' ')}"
    exit 1
  end
end

# Initialize configuration
def init_config
  FileUtils.mkdir_p(CONFIG_DIR) unless Dir.exist?(CONFIG_DIR)
  
  unless File.exist?(CONFIG_FILE)
    File.write(CONFIG_FILE, JSON.generate({ "projects" => {} }))
  end
end

# List all projects
def list_projects
  puts "📋 Available Projects:"
  puts ""
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  if config["projects"].empty?
    puts "  No projects found. Create one with 'cloud new <project-name>'."
    return
  end
  
  config["projects"].each do |name, project|
    puts "  #{name} - #{project['services'].length} service(s)"
  end
end

# Create a new project
def create_project(project_name)
  if project_name.nil? || project_name.empty?
    puts "Error: Project name is required."
    puts "Usage: cloud new <project-name>"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project already exists
  if config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' already exists."
    exit 1
  end
  
  puts "Creating new project: #{project_name}"
  print "Enter project path: "
  project_path = gets.chomp
  
  # Validate path exists
  unless Dir.exist?(project_path)
    puts "Warning: Directory '#{project_path}' does not exist."
    print "Do you want to continue anyway? (y/n): "
    confirm = gets.chomp.downcase
    if confirm != "y"
      puts "Project creation canceled."
      exit 0
    end
  end
  
  # Add project to configuration
  config["projects"][project_name] = {
    "path" => project_path,
    "services" => {}
  }
  
  File.write(CONFIG_FILE, JSON.generate(config))
  
  puts "Project '#{project_name}' created successfully."
  puts "Now add services using: cloud service-add #{project_name}"
end

# List services for a project
def list_services(project_name)
  if project_name.nil? || project_name.empty?
    puts "Error: Project name is required."
    puts "Usage: cloud services <project-name>"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project exists
  unless config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' does not exist."
    exit 1
  end
  
  puts "🔧 Services for project '#{project_name}':"
  puts ""
  
  if config["projects"][project_name]["services"].empty?
    puts "  No services found. Add one with 'cloud service-add #{project_name}'."
    return
  end
  
  config["projects"][project_name]["services"].each do |name, service|
    puts "  #{name}:"
    puts "    Command: #{service['command']}"
    puts "    Directory: #{service['directory']}"
    puts ""
  end
end

# Add a service to a project
def add_service(project_name)
  if project_name.nil? || project_name.empty?
    puts "Error: Project name is required."
    puts "Usage: cloud service-add <project-name>"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project exists
  unless config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' does not exist."
    exit 1
  end
  
  puts "Adding service to project: #{project_name}"
  
  print "Enter service name: "
  service_name = gets.chomp
  
  # Check if service already exists
  if config["projects"][project_name]["services"].key?(service_name)
    puts "Error: Service '#{service_name}' already exists in project '#{project_name}'."
    exit 1
  end
  
  print "Enter service command: "
  service_command = gets.chomp
  
  project_path = config["projects"][project_name]["path"]
  
  print "Enter service directory (press Enter to use project path '#{project_path}'): "
  service_dir = gets.chomp
  
  service_dir = project_path if service_dir.empty?
  
  # Validate directory exists
  unless Dir.exist?(service_dir)
    puts "Warning: Directory '#{service_dir}' does not exist."
    print "Do you want to continue anyway? (y/n): "
    confirm = gets.chomp.downcase
    if confirm != "y"
      puts "Service creation canceled."
      exit 0
    end
  end
  
  # Add service to configuration
  config["projects"][project_name]["services"][service_name] = {
    "command" => service_command,
    "directory" => service_dir
  }
  
  File.write(CONFIG_FILE, JSON.generate(config))
  
  puts "Service '#{service_name}' added to project '#{project_name}' successfully."
end

# Remove a service from a project
def remove_service(project_service)
  if project_service.nil? || project_service.empty?
    puts "Error: Project and service specification is required."
    puts "Usage: cloud service-remove <project>:<service>"
    exit 1
  end
  
  # Parse project:service format
  project_name, service_name = project_service.split(':')
  
  if project_name.nil? || service_name.nil? || project_name.empty? || service_name.empty?
    puts "Error: Invalid format. Use <project>:<service>"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project exists
  unless config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' does not exist."
    exit 1
  end
  
  # Check if service exists
  unless config["projects"][project_name]["services"].key?(service_name)
    puts "Error: Service '#{service_name}' does not exist in project '#{project_name}'."
    exit 1
  end
  
  print "Are you sure you want to remove service '#{service_name}' from project '#{project_name}'? (y/n): "
  confirm = gets.chomp.downcase
  
  if confirm != "y"
    puts "Service removal canceled."
    exit 0
  end
  
  # Remove service from configuration
  config["projects"][project_name]["services"].delete(service_name)
  File.write(CONFIG_FILE, JSON.generate(config))
  
  puts "Service '#{service_name}' removed from project '#{project_name}' successfully."
end

# Edit a service
def edit_service(project_service)
  if project_service.nil? || project_service.empty?
    puts "Error: Project and service specification is required."
    puts "Usage: cloud service-edit <project>:<service>"
    exit 1
  end
  
  # Parse project:service format
  project_name, service_name = project_service.split(':')
  
  if project_name.nil? || service_name.nil? || project_name.empty? || service_name.empty?
    puts "Error: Invalid format. Use <project>:<service>"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project exists
  unless config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' does not exist."
    exit 1
  end
  
  # Check if service exists
  unless config["projects"][project_name]["services"].key?(service_name)
    puts "Error: Service '#{service_name}' does not exist in project '#{project_name}'."
    exit 1
  end
  
  current_command = config["projects"][project_name]["services"][service_name]["command"]
  current_directory = config["projects"][project_name]["services"][service_name]["directory"]
  
  puts "Editing service '#{service_name}' in project '#{project_name}'"
  puts "Current command: #{current_command}"
  print "Enter new command (press Enter to keep current): "
  new_command = gets.chomp
  
  new_command = current_command if new_command.empty?
  
  puts "Current directory: #{current_directory}"
  print "Enter new directory (press Enter to keep current): "
  new_directory = gets.chomp
  
  if new_directory.empty?
    new_directory = current_directory
  else
    # Validate new directory exists
    unless Dir.exist?(new_directory)
      puts "Warning: Directory '#{new_directory}' does not exist."
      print "Do you want to continue anyway? (y/n): "
      confirm = gets.chomp.downcase
      if confirm != "y"
        puts "Service edit canceled."
        exit 0
      end
    end
  end
  
  # Update service in configuration
  config["projects"][project_name]["services"][service_name] = {
    "command" => new_command,
    "directory" => new_directory
  }
  
  File.write(CONFIG_FILE, JSON.generate(config))
  
  puts "Service '#{service_name}' in project '#{project_name}' updated successfully."
end

# Run a project or specific services
def run_project(project_name, *specific_services)
  if project_name.nil? || project_name.empty?
    puts "Error: Project name is required."
    puts "Usage: cloud run <project-name> [<project>:<service> ...]"
    exit 1
  end
  
  config = JSON.parse(File.read(CONFIG_FILE))
  
  # Check if project exists
  unless config["projects"].key?(project_name)
    puts "Error: Project '#{project_name}' does not exist."
    exit 1
  end

  # If we're already in a tmux session, warn the user
  if ENV.key?('TMUX')
    puts "Warning: You are already in a tmux session."
    print "Do you want to create a nested session? (y/n): "
    confirm = gets.chomp.downcase
    if confirm != "y"
      puts "Run canceled."
      exit 0
    end
  end
  
  session_name = "cloud-#{project_name}"
  
  # Kill existing tmux session if it exists
  system("tmux kill-session -t \"#{session_name}\" 2>/dev/null || true")
  
  # Create a new tmux session
  system("tmux new-session -d -s \"#{session_name}\"")
  
  # Get all services or use specified ones
  services = []
  if specific_services.empty?
    # Use all services from the project
    services = config["projects"][project_name]["services"].keys
  else
    # Parse project:service format for each specified service
    specific_services.each do |spec|
      p, s = spec.split(':')
      # If no project specified or matches current project
      if p.nil? || p.empty? || p == project_name
        # Check if service exists
        if config["projects"][project_name]["services"].key?(s)
          services << s
        else
          puts "Warning: Service '#{s}' does not exist in project '#{project_name}'. Skipping."
        end
      end
    end
  end
  
  if services.empty?
    puts "Error: No services to run for project '#{project_name}'."
    system("tmux kill-session -t \"#{session_name}\" 2>/dev/null || true")
    exit 1
  end
  
  # Configure tmux panes based on number of services
  num_services = services.length
  
  # For the first service, use the initial pane
  service = services[0]
  command = config["projects"][project_name]["services"][service]["command"]
  directory = config["projects"][project_name]["services"][service]["directory"]
  
  # Set the window title
  system("tmux rename-window -t \"#{session_name}:0\" \"#{service}\"")
  
  # Send commands to the first pane
  startup_cmd = "cd \"#{directory}\" && clear && echo \"🚀 Starting service: #{service}\" && echo \"📁 Directory: #{directory}\" && echo \"🔧 Command: #{command}\" && echo \"\" && #{command}"
  system("tmux send-keys -t \"#{session_name}:0.0\" \"#{startup_cmd}\" C-m")
  
  # Create additional panes for other services
  services[1..-1].each_with_index do |service, idx|
    i = idx + 1 # adjust index to start from 1
    command = config["projects"][project_name]["services"][service]["command"]
    directory = config["projects"][project_name]["services"][service]["directory"]
    
    # Create a new pane
    if i % 2 == 1
      # Split horizontally for odd-indexed services
      system("tmux split-window -h -t \"#{session_name}:0\"")
    else
      # Split vertically for even-indexed services
      system("tmux split-window -v -t \"#{session_name}:0\"")
    end
    
    # Send commands to the new pane
    startup_cmd = "cd \"#{directory}\" && clear && echo \"🚀 Starting service: #{service}\" && echo \"📁 Directory: #{directory}\" && echo \"🔧 Command: #{command}\" && echo \"\" && #{command}"
    system("tmux send-keys -t \"#{session_name}:0.#{i}\" \"#{startup_cmd}\" C-m")
  end
  
  # Auto-arrange panes in tiled layout
  system("tmux select-layout -t \"#{session_name}:0\" tiled")
  
  # Add a help window
  system("tmux new-window -t \"#{session_name}:1\" -n \"Help\"")
  system("tmux send-keys -t \"#{session_name}:1\" \"echo -e \\\"\\n🌟 Cloud Project Manager - #{project_name}\\n\\nActive services:\\n\\\"; \" C-m")
  
  services.each do |service|
    command = config["projects"][project_name]["services"][service]["command"]
    system("tmux send-keys -t \"#{session_name}:1\" \"echo \\\"  - #{service}: #{command}\\\"\" C-m")
  end
  
  help_text = "echo -e \"\\nTmux Keyboard Shortcuts:\\n  - Ctrl+b, arrow keys: Navigate between panes\\n  - Ctrl+b, z: Zoom in/out of current pane\\n  - Ctrl+b, d: Detach from session\\n  - Ctrl+b, 0-9: Switch to window number\\n  - Ctrl+b, c: Create new window\\n\\nTo reattach later: tmux attach-session -t #{session_name}\\n\""
  system("tmux send-keys -t \"#{session_name}:1\" \"#{help_text}\" C-m")
  
  # Switch back to first window
  system("tmux select-window -t \"#{session_name}:0\"")
  
  # Attach to the session
  system("tmux attach-session -t \"#{session_name}\"")
end

# Print help
def show_help
  puts "Cloud Project Manager - A tool for managing multi-service projects"
  puts ""
  puts "Usage:"
  puts "  cloud [list]                           List all projects"
  puts "  cloud new <project>                    Create a new project"
  puts "  cloud services <project>               List services for a project"
  puts "  cloud service-add <project>            Add a service to a project"
  puts "  cloud service-remove <project>:<service>  Remove a service from a project"
  puts "  cloud service-edit <project>:<service>    Edit a service"
  puts "  cloud run <project> [<project>:<service> ...]  Run all or specific services of a project"
  puts "  cloud help                             Show this help message"
  puts ""
  puts "Examples:"
  puts "  cloud new client-name                       Create a new project called 'client-name'"
  puts "  cloud service-add client-name               Add a service to 'client-name' project"
  puts "  cloud run client-name                       Run all services for 'client-name'"
  puts "  cloud run client-name client-name:api client-name:frontend  Run only api and frontend services"
end

# Main function
def main(args)
  check_dependencies
  init_config
  
  command = args.shift || "list"

  case command
  when "list"
    list_projects
  when "new"
    create_project(args[0])
  when "services"
    list_services(args[0])
  when "service-add"
    add_service(args[0])
  when "service-remove"
    remove_service(args[0])
  when "service-edit"
    edit_service(args[0])
  when "run"
    run_project(args[0], *args[1..-1])
  when "help", "--help", "-h"
    show_help
  else
    puts "Unknown command: #{command}"
    show_help
    exit 1
  end
end

# Execute main with all arguments
main(ARGV)