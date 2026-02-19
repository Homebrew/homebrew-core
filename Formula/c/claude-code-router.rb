class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-2.0.0.tgz"
  sha256 "c09fd569577d13e5fd15da40623df8d561f8816eb0f0a045839f4302a9862737"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "945809d609dde32f124e127be19d58734dbd9f01c7d2caed0fcaee08236da477"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccr version")
    assert_match "Status: Not Running", shell_output("#{bin}/ccr status")
  end
end
