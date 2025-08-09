class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.7.3.tgz"
  sha256 "9f15ba22bc40b0443e4036f05381b5e1ca4fdb6822f7fd734b4258c2a97bdc29"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "2948524d1c9ca928cab560d78d0e5d504af70ab2616804108e7f2882902221ba"
    sha256                               arm64_sonoma:  "2948524d1c9ca928cab560d78d0e5d504af70ab2616804108e7f2882902221ba"
    sha256                               arm64_ventura: "2948524d1c9ca928cab560d78d0e5d504af70ab2616804108e7f2882902221ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "139b3ba46defd085f326ef82615171d7306ca8a9153571d465f5271db0417440"
    sha256 cellar: :any_skip_relocation, ventura:       "139b3ba46defd085f326ef82615171d7306ca8a9153571d465f5271db0417440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60fc25ee8816f51c388466767af6c1e22ad91568954af15543e1cd56681cccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d464d072ba6476ddee6f292be16a765ad1a27f35594930384604385f6dfaa792"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    port = free_port
    pid = fork do
      exec bin/"backlog", "browser", "--no-open", "--port", port.to_s
    end
    sleep 2
    assert_match "<title>Backlog.md - Task Management</title>", shell_output("curl -s http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
