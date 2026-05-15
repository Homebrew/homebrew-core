class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.8.tgz"
  sha256 "29dd3b943a297bc26be06327b4acc52af4fd16effd3db41cc8b4047d28119b13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0628fc64d4fad8134adeb3b07061aff43c8bc609f2e82da6538603884af9b605"
    sha256 cellar: :any,                 arm64_sequoia: "0710548c24641ca5dc9285ea9f4fcd2f6a3d4a6445ee21640834b40fbc2ba9dc"
    sha256 cellar: :any,                 arm64_sonoma:  "0710548c24641ca5dc9285ea9f4fcd2f6a3d4a6445ee21640834b40fbc2ba9dc"
    sha256 cellar: :any,                 sonoma:        "71c8f6166ba8a83bfaf369de48860bdf1398ccb6a62aa4516ac57c57392c80f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "069f9a9332009e5de59d93abb717338f261b54c2d42fcc49d947738dabfb5072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831cd04ab5e42f67d14541bede510b9c4393d862d12a9a98330d631b92ed31b2"
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
