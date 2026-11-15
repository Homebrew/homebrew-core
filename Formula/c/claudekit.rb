class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.9.5.tgz"
  sha256 "9059948267aeaf80b8d06805b7960fa508efbe6b446eb1ddda6e616987276c23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab214114f730abb2e91457d273f6f067aa29be48fa8541e3e85f002f64e4f8e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudekit --version")
    assert_match "Hooks:", shell_output("#{bin}/claudekit list")
    assert_match ".claudekit/config.json not found", shell_output("#{bin}/claudekit doctor 2>&1", 1)
  end
end
