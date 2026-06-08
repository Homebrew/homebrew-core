class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "e8d8ad21dd3252984e8a41659fa772631b19bd81c58b7220c1086484d6162a33"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ba91a1909cafbc6d52360fc6f4e771b908e0871eed6d46ded8e2fdea31bbdb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af1c7791a962212f3a5374d36500c98fdb963ddb3fd0311333205e49fa38a570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa7079b26e8b192d519864e7ed48e8ea3323f9af7e2e73c138f74c6b1442ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "65a845037fd71c807299d062f4b74417684ca48f3cc79a272cc90505026b849e"
    sha256 cellar: :any,                 arm64_linux:   "f9fba59b20d3ae462a61b8e949c1a9440509b154d2dfc33d47df8b8bb1e0270c"
    sha256 cellar: :any,                 x86_64_linux:  "a27daabd8fcf55c53e81a2cf46df821230451128206cef0354bd6d7834be0e7c"
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
