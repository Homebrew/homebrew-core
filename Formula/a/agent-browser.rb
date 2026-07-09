class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "370f91c688c7b92ded5c7aaedc190ab4c68c353f0b12c24948a81b6549176310"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "922aa24b9ee8f70124ab7da315348c11ce7af8ea8b25e778a788c3d8c7586df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf952493413515338e3d98eb026a0b6aa6837207d1985891318ea133fab21a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be6e34f81e5ec201be407a87cc09ad545624f17a0bc23cb7db797b481c36e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "0de174781f7aa2af46405daa1dd9cc11abb5d5acf13a4a76474ed6e2319936b1"
    sha256 cellar: :any,                 arm64_linux:   "c8864da9d6a42444a91fbd080ffe34724935a83f158df6ac2099d774d5ee463a"
    sha256 cellar: :any,                 x86_64_linux:  "5c098eb4bf8c905451213dff86875fe3e2c27155bffbc189544257676ab66d73"
  end

  depends_on "rust" => :build
  depends_on "node"

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
