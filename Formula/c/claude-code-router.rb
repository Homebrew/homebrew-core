class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.0.tgz"
  sha256 "0eeaa1f4bc4662ed87c99149bd91f9906879b4ba002825a200d15f41f5ae8a66"
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
