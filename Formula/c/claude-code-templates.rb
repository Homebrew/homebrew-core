class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.16.tgz"
  sha256 "1e451ce1049ecf5beed9a0f023d51997c7bd0f9868e85b1dfddb9a5b875d8cbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04972771caac1cb6b1a8cd58ec7fcf071c5c426cbcc9072caa9fea75f049e73f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
