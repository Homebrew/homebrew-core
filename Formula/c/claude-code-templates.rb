class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.32.1.tgz"
  sha256 "7b7d42d23bae1382e3f1b305ff89c24da32f901827a1e84075b07c40a66d624b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43ea28a98de84dce18fccb12be8ebe9e5f7423d4a5956abcbdd95bd90dc9d982"
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
