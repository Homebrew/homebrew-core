class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.33.1.tgz"
  sha256 "7ffbfde312c78f7efeec5e4596d625b3bb1e52f20f355d95dffd6552036a3a41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ff8dd55a0511906210e648c4031eb12d2e653aec300a8e8dd42b9a31d5a39f6"
  end

  depends_on "node"

  conflicts_with "proj", because: "both install `cct` binaries"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-code-templates --version")

    output = shell_output("#{bin}/claude-code-templates --command testing/generate-tests --yes")
    assert_match "Installed 1 of 1", output
    assert_path_exists testpath/".claude/commands/generate-tests.md"
  end
end
