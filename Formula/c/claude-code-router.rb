class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.70.tgz"
  sha256 "13fc8bcf28649ed68228f670cde4d8ae4a5078e5846b058ec4c5bb92bce680f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36bf0ea14f34034f67767d9b0c9ee6aaed71808d76b2ed3541d633f15a243b43"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccr version")
    assert_match "Status: Not Running", shell_output("#{bin}/ccr status")
  end
end
