class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.24.tgz"
  sha256 "8f4a0f598a041732eeb5180a4af48ea371c79fcb178ea6206fbd2370766360e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6c51693d75fbdbc543402da8e9452349cb0d12baf52cc8cc3877e20abdc851f"
    sha256 cellar: :any,                 arm64_sequoia: "d448079d04ee4ba47cc3eca9f6e01e3fbc3f4eac11c743e34f228c4e9d8bb45d"
    sha256 cellar: :any,                 arm64_sonoma:  "d448079d04ee4ba47cc3eca9f6e01e3fbc3f4eac11c743e34f228c4e9d8bb45d"
    sha256 cellar: :any,                 sonoma:        "dc3ca5a3b5582eea3dddfcea6668837c85d3fc43718c4b89b597e6474c248e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b5ffac4d1f3a4f024b6062a0ba19b6361c3b05c72fd7b7223fef7523627e5e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a04ec727a06cd741dcc33b5c8bb33671fc2ec58cfaa60ff43ff90a3f6e3f573"
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

    # The bundled Discord plugin ships unresolved nested dependencies and a
    # prebuilt macOS arm64 module that fails Homebrew linkage fixups.
    rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    llama_target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"
    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(llama_target) &&
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
