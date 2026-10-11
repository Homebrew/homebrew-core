class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.30.0.tgz"
  sha256 "46a920e5380ac2e871df4c8c6d121330ddc22c2c3ec483f158c78462f1d58510"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e4f1c7efcfb4c88d53e17301b1a90ea87172c0080c7b65cb48de6c1b5dda227"
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
