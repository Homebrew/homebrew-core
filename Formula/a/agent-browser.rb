class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.3.tgz"
  sha256 "088f73ca84118756d1713f6d25d00d2e3b0c5a7a64af0d177e2d7f2ec8c28482"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ef58e945d42feb6c6acee274e3cdd513387ab49ae6871b0907d290a8afff637"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef58e945d42feb6c6acee274e3cdd513387ab49ae6871b0907d290a8afff637"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef58e945d42feb6c6acee274e3cdd513387ab49ae6871b0907d290a8afff637"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a47311ce7a334469eba1b66ccd85c9270b31e73a908ee13ccdc9eaa50af34b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fc7986c6cfa355f040cf70fc3953092eadd1a7558cae678727e3cf32025c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b90de0f4c8e11ad75fd607607875d9790ecd662cd3f3f7fdfc9d5dbcdb2c0d9e"
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
