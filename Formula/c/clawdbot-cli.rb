class ClawdbotCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://clawd.bot"
  url "https://registry.npmjs.org/clawdbot/-/clawdbot-2026.1.24-3.tgz"
  sha256 "a00acd33ac20787fbd342db2bc36db15b2483f88e1f8b159cf1bc37a6eb1a828"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/clawdbot/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    native_prefix = if OS.mac?
      Hardware::CPU.arm? ? "mac-arm64" : "mac-x64"
    elsif OS.linux?
      Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
    end
    if native_prefix
      node_modules.glob("@node-llama-cpp/*").each do |dir|
        basename = dir.basename.to_s
        next if basename.start_with?(native_prefix) &&
                basename.exclude?("cuda") &&
                basename.exclude?("vulkan")

        rm_r(dir)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawdbot --version")

    output = shell_output("#{bin}/clawdbot status")
    assert_match "Clawdbot status", output
  end
end
