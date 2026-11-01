class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "b3d9d60b8a38f05e0f9b4d84d9e0b6995c21df2eb963eefb703008682a69f3bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30dd23fdcfcb6cfc512ad2b139e189c20a85380a972a2562eaceadb370c38744"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02916d2d362c055ae76f051e33eacd5bb000508f82603e139b7c0646a662428f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3da3c3a84e7c2241f6859a9596ee605fa816908f894c97f2556d5513f141864"
    sha256 cellar: :any,                 arm64_linux:       "1e28f9b49524afa2a7e78f4176c855e45ce9fc93360daae8c82578dfcb3f1b1b"
    sha256 cellar: :any,                 x86_64_linux:      "07dd2acb4a16d8e76a111330f4146d3787c99a5aab8fd1a18c4c1e05c5e4f389"
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
