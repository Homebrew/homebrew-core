class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.41.2.tar.gz"
  sha256 "5deccde57db7ed416d46a57e3c2767fba74f96e750d1d8fabe79bfa1f4bd228b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b10a53c07793e94d38341ab2f778bcb42fed19cbca3c42b80b249060753ac2f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d6f6f7ac5856dc7bcb8d3a280398b58cfe458d70a9708f9d7d3bff6916dfa1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "810e1473cc087f4fde5c63c2bf805acfa27ed960a67e982207a582fec3b54bbc"
    sha256 cellar: :any,                 arm64_linux:       "c4defb5be6dac28f283c34bd413d1aee6714d45a836673a1c1416a8aa6bc9566"
    sha256 cellar: :any,                 x86_64_linux:      "5ff27fa8fcf8b9a396da7b4a8b76b8be7d379c82b0ed533af25241a02b13f185"
  end

  depends_on "rust" => :build
  depends_on "node"

  allow_network_access! :build

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
