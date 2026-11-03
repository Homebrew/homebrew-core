class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.31.0.tgz"
  sha256 "52813fb1775f1c2c1a4c4aa91b1a34a2fd4635ed0dfcb15caf5d86a59ef3898a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30117439299230644ea62444b19af55c888446dcd2c0a724b0bbc96fd6e783d9"
  end

  depends_on "node"

  conflicts_with "proj", because: "both install `cct` binaries"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Installed 1 of 1", output
    assert_path_exists testpath/".claude/commands/generate-tests.md"
  end
end
