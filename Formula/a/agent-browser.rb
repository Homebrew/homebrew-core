class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.12.0.tgz"
  sha256 "07201ca706527cb379c1e36c9362ac1bf9e5a30154910178af6fa736a8cb7ac7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f920126198fd590818593b9efa3f082456e3e453cfcbc1374ee9585500bb967"
    sha256 cellar: :any,                 arm64_sequoia: "6e14a46e33ab593e92608c3c9190af0268da77804ff4f7b18e84dd0cade60cd1"
    sha256 cellar: :any,                 arm64_sonoma:  "6e14a46e33ab593e92608c3c9190af0268da77804ff4f7b18e84dd0cade60cd1"
    sha256 cellar: :any,                 sonoma:        "a4be3078f7b4a9a8f586c816e2b67978705854458acc187b6a2561c8f371e4ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa00b811a0317b1f7b80cddc4e54d9af08a0c4ae8179369c0470d1e935cc8f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ba038b8a47aec534ef2bf05332c4f09c0f35bf0c67e61d1436a54322a92dd7"
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
