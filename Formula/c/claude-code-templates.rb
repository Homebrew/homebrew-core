class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.32.2.tgz"
  sha256 "e04613cff765b95f8a9e6d64da63eb8fc543662bcad1d43ebdd2c6663b14cc35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca2d3a94879b68f423ec6984f85afc5f584c4b3313d08b6c7ae1b52066780b85"
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
