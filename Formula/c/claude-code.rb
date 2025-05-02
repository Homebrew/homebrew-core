class ClaudeCode < Formula
  desc "Agentic coding tool - use 'claude' as the command"
  homepage "https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-0.2.99.tgz"
  sha256 "37ec931cb48ea8fc021060a8c640372b3c6e18fde635bfc166a5da10b13ecb6f"
  license :cannot_represent # See https://github.com/anthropics/claude-code/blob/main/LICENSE.md

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # add a meaningful test here, version isn't usually meaningful
    assert_match version.to_s, shell_output("#{bin}/claude --version")
  end
end
