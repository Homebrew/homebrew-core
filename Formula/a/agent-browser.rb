class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.24.0.tgz"
  sha256 "3f864472952d109b2508b52f6859ff7a0733e0892ba7c11ebf90f0c9224abb4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdddf2727388e7e572bfb0a385987a560dcee8e2564cbaa9b448b0dbed851524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdddf2727388e7e572bfb0a385987a560dcee8e2564cbaa9b448b0dbed851524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdddf2727388e7e572bfb0a385987a560dcee8e2564cbaa9b448b0dbed851524"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3a30817c0a154e298980a8af71bd9f69e4cefceb84b3514067c5cb82946cd85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84df39269d2813727c5806bd1f126152645d1ead4e3f27ddd3ca83a9defbf9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d827e311f47811c38bb75a55423a181f7e82a9a0d5513e8f85ec8090fd1b1d"
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

    # Install shell completions
    bash_completion.install node_modules/"completions/agent-browser.bash" => "agent-browser"
    zsh_completion.install node_modules/"completions/agent-browser.zsh" => "_agent-browser"
    fish_completion.install node_modules/"completions/agent-browser.fish"
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
