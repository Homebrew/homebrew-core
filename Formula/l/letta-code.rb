class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.18.tgz"
  sha256 "7df19ce6c1d6c04bf2f87fb59a68ab480a6116ba954cfd3c7b76937eb926586c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c52bf40ca198721a1b00029b2e074fdd9bfff0fdba8d802df8d2e81a9bd12a99"
    sha256 cellar: :any,                 arm64_sequoia: "f79189cdcd0ffac356a617f04986fff4aab165d896cc4844f22db02365c80263"
    sha256 cellar: :any,                 arm64_sonoma:  "f79189cdcd0ffac356a617f04986fff4aab165d896cc4844f22db02365c80263"
    sha256 cellar: :any,                 sonoma:        "063e1471b0936384ee98070f1f103dfb51def92434fec0155249c46f96789a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e922681d018d067c0855e927c463b8eeeee8aab94cf9dd89964f4092d7b4b416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d55516a93b53e2292ccce179e738445757ec96f63e48d24baad2cff701a51b"
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
