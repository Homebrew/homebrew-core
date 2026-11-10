class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.33.0.tgz"
  sha256 "a06832ba91bc54014ef0494da2839a80b83a1aa65730dfa3229bf23cce93dfff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33b4947fb58b7226dab9f00bd1762ebfe0e8977c0cd1ce6e60447a366ea7a421"
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
