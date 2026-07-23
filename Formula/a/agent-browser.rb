class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "89484f6e2f3a72a04661060013aaa8ec76cb3c6af1e0d8680ca35cd19cb35d88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb40c7ebb529ea3feab512e6fded1dd3c59b7b3dfa7562d973f396a5a15ee33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6820cb05275b15f2e4e7ef16a63fb207777de738bf6607879b3bf9bf0ccc66a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a68680ae1e5f673656f325df8019b6552d82da53091af58877dbc0fd01689e9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77ebb18e197f3a707e3efd00b2881610ef784582c4eefe0afb808cc4da7c19bc"
    sha256 cellar: :any,                 arm64_linux:   "ed95d034c1ec2ba4244c0a7f5d85ef8f1cb9700e19d9aa79d048d3ef1a208326"
    sha256 cellar: :any,                 x86_64_linux:  "00bfcba10d1ac635f1305fe5fd57d251c58c736b98d1c68a68a6f49051052e0c"
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
