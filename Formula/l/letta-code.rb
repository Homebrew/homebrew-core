class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.19.5.tgz"
  sha256 "629f22ac3b97e27c9052871e839ef53477d0a47a205b8592c31b1cafb1f0f42b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a73901f061da506855142d90b7883642b4eb15371c60a7d93901333bbcf0c11a"
    sha256 cellar: :any,                 arm64_sequoia: "69d276684fa43364b8d9cc1adc36b6049d92ed1ef4e077ec285e76f1df6f9e07"
    sha256 cellar: :any,                 arm64_sonoma:  "69d276684fa43364b8d9cc1adc36b6049d92ed1ef4e077ec285e76f1df6f9e07"
    sha256 cellar: :any,                 sonoma:        "8a82250191fb8921db89cc839ab738624794485c36ca753cb89958898f3e8e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "027f1cf6b01fa8b131a59e3d11d9670d6e97ac2b991da85fc535aecdbfed10e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a15474819d8df687234f378250220437c2a167f915f304641b1f272b16e38ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
