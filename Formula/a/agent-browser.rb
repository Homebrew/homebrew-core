class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "2c00cf01d30d6f74ec71d3d8eec881101f0298807de1c09933f190783b0f06f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e2383dce76f09d504d5af34c6fd51254d86070cf4451f85ca1eac8d15852f11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81755f0971317c62011074e06c3ebea8d46fb5de7b3cc1b3c62b74e8ce698982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954fb259ad27bf23fc37138d638d2cead2924825ab9463da84adbb5117e726c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b9485e7482cc8905fe5accfabd3dce71458fd3c789f7aaecd8acbe60ece96d"
    sha256 cellar: :any,                 arm64_linux:   "e506e9d6b0e912a5a0486caaa7ca1a14db6073ed46e37cd10f1f8b556c9b8eaf"
    sha256 cellar: :any,                 x86_64_linux:  "0a1130426dfcd3d8cb505dec1898bca54a95cd617120d473bd7ca61d7a003463"
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
