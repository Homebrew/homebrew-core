class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "b3d9d60b8a38f05e0f9b4d84d9e0b6995c21df2eb963eefb703008682a69f3bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cfca4e66eef223893780291b01cc550e606526fed9835c3279108fec22acf1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0da6bf349d5e3515bdab88a7115b58833e51e4be05dfb563e9893d214d8f5f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdd4967f31437f4d1fdda7b11054138ad40e468f54bb8064ad0345a4ec1b35cc"
    sha256 cellar: :any,                 arm64_linux:       "4dc20edf8ae3cd3f86a21f7ba635fe5b3b6310fca8dae5c110f8320e82e2eaa3"
    sha256 cellar: :any,                 x86_64_linux:      "21d41905e0c2ead1451a2bd9d00237c96eced52bbf8b9a76e4799e7e05bba69f"
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
