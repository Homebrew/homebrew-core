class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.25.3.tgz"
  sha256 "9c898eba0fcfffc323f560ef66bb1a02b3d07b072aed8238d4b6c6c46a41c8db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9dcd3a83157448dddfb958301a73b308f84be984a56297878f0d869f5fd037b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9dcd3a83157448dddfb958301a73b308f84be984a56297878f0d869f5fd037b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9dcd3a83157448dddfb958301a73b308f84be984a56297878f0d869f5fd037b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7362741d1e8f6e92a10f08f80562a399aa4170aa68659842a4234fa6289596c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce9bcf1dd27a683648b14e53e158eb0b2a6328b178cfc404fd294a2a8f2cc00c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d22d10ac9c01beb668090a6e63ef9d5d0dc1a4eba08fc6eccd6203b44b069b"
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
