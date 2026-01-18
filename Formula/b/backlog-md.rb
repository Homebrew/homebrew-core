class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.32.0.tgz"
  sha256 "f8de2fddee2c313f19599fa8d9ed57cf12e211498eceba52145e39de2f371e74"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e0dca99801554ed036a3fff4bfa5270e08394cef6ffd3e09818bf16664661d05"
    sha256                               arm64_sequoia: "e0dca99801554ed036a3fff4bfa5270e08394cef6ffd3e09818bf16664661d05"
    sha256                               arm64_sonoma:  "e0dca99801554ed036a3fff4bfa5270e08394cef6ffd3e09818bf16664661d05"
    sha256 cellar: :any_skip_relocation, sonoma:        "a03a35529f4854bdaf77844024f06c6b62938f15b158cd9fd5fe1b4ed0cbe99e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac7ad24f973a112c1c914dff086aafbbfbee8a5918020c07236e4f1f865baabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e5728e3a524a34d5ba0890aaeb8be020cddba71c6dbc4aaa80e072f347e702"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
