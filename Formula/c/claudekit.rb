class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.9.4.tgz"
  sha256 "b6b8887e129ac42773d2e6884e39300bcf44b7e24bdb5124d3c809fd9bde4d94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d6a3fc977278f8f2ee982329648ef0181c69e47823b60f36d4e4fdb51a7dea0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudekit --version")
    assert_match "Hooks:", shell_output("#{bin}/claudekit list")
    assert_match ".claudekit/config.json not found", shell_output("#{bin}/claudekit doctor 2>&1", 1)
  end
end
