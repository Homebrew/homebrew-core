class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "1b8ae0fd469081012c2ead4aa6e587033beb40fb0d6d005e7cec1ccd9474f567"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbb1b03c42ba2430750fa4f845fd6e11f7aeb091782262782bab7bec90ae9018"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1e00e931e357e633d6b434ce23b064cddac3375d17b8927df867b78abb39445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59c78f9259377057d633381a954cad42532d8cd02cc46b56bd9f98a00f0c5117"
    sha256 cellar: :any,                 arm64_linux:       "ca310f388a8616dad4b024cb846238d5df446122ffb1a011145fcb754a17dba5"
    sha256 cellar: :any,                 x86_64_linux:      "30eac08d34e228be8469bc9963cff397f7721afb7214e79ab4773613bcc6c1e8"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "run", "build:native"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
