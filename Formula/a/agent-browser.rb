class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "c49d32065058b06b60ac505ed0b562f469a6ab68566e510f7518166791dac7eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3dd8e1b9a013610b8396b85f1c81040177a32a8a7bf9dff9b5392036b23ca76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca71a4aaad6aa008adc4a3b6e5e601b7ef29ee6cce84a10dc78c270fcc2d2a0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa03778d71d59beedb500d3a92f8335850731e3cc90b24afd314d49d874873a3"
    sha256 cellar: :any,                 arm64_linux:       "b67c013ec87eb31b8631673d8b62759824cfbb91696b8cacf399f8196b17af3d"
    sha256 cellar: :any,                 x86_64_linux:      "74ee191b9a4ae9cfd1ae0f4fdbe344da5849357c5d13ca07c0f852a2e2cc032f"
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
