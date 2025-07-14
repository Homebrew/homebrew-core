class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.3.1.tgz"
  sha256 "9104a8b90827f46f6ac82b2ae1074d5209222cd6e1fc4e1cf05fbfbce5338e01"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "0132197f0eea90d9213b0ac48ed235bc1c4b75ca5070908d573e3b4235912709"
    sha256                               arm64_sonoma:  "0132197f0eea90d9213b0ac48ed235bc1c4b75ca5070908d573e3b4235912709"
    sha256                               arm64_ventura: "0132197f0eea90d9213b0ac48ed235bc1c4b75ca5070908d573e3b4235912709"
    sha256 cellar: :any_skip_relocation, sonoma:        "40e7c704e0a6051dc9de0fda6a45c4e81fec068420d6713e7b34721696c616f2"
    sha256 cellar: :any_skip_relocation, ventura:       "40e7c704e0a6051dc9de0fda6a45c4e81fec068420d6713e7b34721696c616f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bba054fb3a6f03208638e9c54d5ed15e2ba71e66276e3b7bab540955a37e2130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c9daa65038f348273fee71e7040494f781f43e4743dce3bcf412001c25068b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    (testpath/"test").mkpath
    cd testpath/"test" do
      system "git", "init"

      # Test backlog init command requires interactive input
      require "open3"
      Open3.popen3("#{bin}/backlog", "init", "test") do |stdin, _stdout, _stderr, wait_thr|
        stdin.puts "y"
        sleep 1
        stdin.puts "y"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.puts "\n"
        sleep 1
        stdin.close
        wait_thr.value # Wait for process to complete
      end

      assert_path_exists testpath/"test/backlog"
    end
  end
end
