class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.26.0.tgz"
  sha256 "8a48cf4110d7dc2c12c1c4d6d25e0babdfa31604b537f05df0dc835fe2f854bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1451c581ff03f9380b7782faa4b8bfa2619d08f2ace500760bd37b0cb2d217f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1451c581ff03f9380b7782faa4b8bfa2619d08f2ace500760bd37b0cb2d217f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1451c581ff03f9380b7782faa4b8bfa2619d08f2ace500760bd37b0cb2d217f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "10fd338c7444b82beaf27dcc678ce978f182e8f0ded512f7efedbbab5fe7a652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36ab9149b001ebe065a5df80c08f94a7d68107bdbf81a5d484a36925a79b756f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae8ffc8a2a28db39d2e3b95393372bfe3ff2c156c8b51ddd4715a54ee00ca64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
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
