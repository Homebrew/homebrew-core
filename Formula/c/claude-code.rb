class ClaudeCode < Formula
  desc "Agentic coding tool that helps you code faster from your terminal"
  homepage "https://docs.anthropic.com/en/docs/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.3.tgz"
  sha256 "c7fae39e821c4d473147f4a597cc5d4855b1e79bf0fdff379a865054cc234570"
  license "MIT"

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "#{version.to_s} (Claude Code)", shell_output("#{bin}/claude --version")
  end
end
