class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9f7b8e0ff1ad2c414b0661e3910382c47d0e3cdc72ece07c00cf7f6319657074"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ece820bb4131e01775055576f3c4583d8ef2bbe72b947f50c24a4e5c871921d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25f2da0592d21272c7cb9e86a05d84ae0213048fff28f59618f73705b183f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35c1c0c14795234e8c54e0311684769dcd69bbac7f2ac4c38a06ed0185538c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "75700283d2474e6c8a9e6fbfc79112da5a6116696bac61490206423bf398f0ab"
    sha256 cellar: :any,                 arm64_linux:   "fb0b771f164107cd1354529504aa317961e0997ed050cbdb4435b5e6a18ca7d9"
    sha256 cellar: :any,                 x86_64_linux:  "b4048a43ca45bf8f8b93099d4929c0db197fd62b1a23eafe7f14df4bf49e52e1"
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
