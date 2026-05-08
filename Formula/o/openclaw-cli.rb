class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.6.tgz"
  sha256 "3f8f42181f0fbc99fc17420de002a1e28c73cd643dbb4bdbc4faf63f4a46dbce"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27c33748f6a0b6708cc32186db29c54b72b4add1bc417a5eb68914166128140e"
    sha256 cellar: :any,                 arm64_sequoia: "777cafc0a99e97200e3c25d079675600edabf5966cd7fcaad82c4fc958fc51be"
    sha256 cellar: :any,                 arm64_sonoma:  "777cafc0a99e97200e3c25d079675600edabf5966cd7fcaad82c4fc958fc51be"
    sha256 cellar: :any,                 sonoma:        "73bec1636b41f49896ac71092f5063a462230ac7a9367e6b008f660e729c5540"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e98d4ec38e0fb0f07de59cdc1960f578dd8af6798c0bf44a10075e82f742d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d330c327017dc2bba920f11bb44c0d26c1b9701e4d8fbdd08ca26f880a233f92"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"

    node_modules.glob("tree-sitter-bash/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != target
    end

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    koffi_target = "#{OS.kernel_name.downcase}_#{arch}"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != koffi_target
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
