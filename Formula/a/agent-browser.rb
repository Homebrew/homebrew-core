class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.4.tgz"
  sha256 "e1fb3e494733a7b5bc9fa9f19803534f4158183d224e6cbaa854521944a087c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec60500b96d8b534d07b887832445544cdb90903542da9d0eb10d63d475ba1ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec60500b96d8b534d07b887832445544cdb90903542da9d0eb10d63d475ba1ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec60500b96d8b534d07b887832445544cdb90903542da9d0eb10d63d475ba1ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14fd9d4005a323c0254561b47e3b86a6a2a4b1d3f026fdf7b433d7f31bb72f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a787234369b7458e456f9a2d50c7b4dd0a17593c16376fef60d73a980b4bb81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66caca5ceb0e8e60abc4b4bb93fe1dd4f43b1f0e873572cbd0c1330a74a372fb"
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
