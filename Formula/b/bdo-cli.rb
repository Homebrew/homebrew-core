class BdoCli < Formula
  desc "Collection of helpful shell scripts for Git and GitHub operations"
  homepage "https://github.com/hellobdo/bdo-cli"
  url "https://github.com/hellobdo/bdo-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5c67911ed56cc628fc88f51d7866b1af0ba3cb452e66ada1bd438ad07ba4c123"
  license "MIT"
  
  depends_on "gh"

  def install
    # Create scripts directory in the Homebrew prefix
    (prefix/"scripts").install Dir["scripts/*.sh"]
    
    # Create the executable
    (bin/"bdo-cli").write <<~EOS
      #!/bin/bash
      
      if [ "$1" = "create" ]; then
        bash "#{prefix}/scripts/create.sh" "${@:2}"
      elif [ "$1" = "push" ]; then
        bash "#{prefix}/scripts/push.sh"
      elif [ "$1" = "branch" ]; then
        bash "#{prefix}/scripts/branch.sh" "${@:2}"
      elif [ "$1" = "react" ]; then
        bash "#{prefix}/scripts/react.sh" "${@:2}"
      elif [ "$1" = "checkout" ]; then
        bash "#{prefix}/scripts/checkout.sh" "${@:2}"
      elif [ "$1" = "create-react" ]; then
        bash "#{prefix}/scripts/create-react.sh" "${@:2}"
      elif [ "$1" = "vitest" ]; then
        bash "#{prefix}/scripts/vitest.sh" "${@:2}"
      elif [ "$1" = "list" ]; then
        echo "Available commands:"
        echo "  bdo-cli create <repo-name> - Create and initialize a new repository"
        echo "  bdo-cli push - Add, commit, and push changes"
        echo "  bdo-cli branch <branch-name> - Create and push a new branch"
        echo "  bdo-cli react - Create a Vite React app"
        echo "  bdo-cli checkout - Reset to match remote main branch"
        echo "  bdo-cli create-react - Create a directory with a Vite React app"
        echo "  bdo-cli vitest - Setup Vitest in a React project"
      else
        echo "Unknown command: $1"
        echo "Run 'bdo-cli list' to see available commands"
        exit 1
      fi
    EOS
    chmod 0755, bin/"bdo-cli"
  end

  test do
    assert_match "Available commands:", shell_output("#{bin}/bdo-cli list")
  end
end 