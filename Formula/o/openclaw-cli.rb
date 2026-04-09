class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.9.tgz"
  sha256 "aae282abf8aa388b10baf32732c64eb3f56c976ae8f74f136563aadb50dc4bd0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5aff3bd5f70e2669a015a1f28403935cdc49468fd30e0ab23f7e736a14d6eb7"
    sha256 cellar: :any,                 arm64_sequoia: "18f4ddb86baf28f59fe75fb9a64eabf6208bc4bbf873f840f5d03a9b2b2fe899"
    sha256 cellar: :any,                 arm64_sonoma:  "18f4ddb86baf28f59fe75fb9a64eabf6208bc4bbf873f840f5d03a9b2b2fe899"
    sha256 cellar: :any,                 sonoma:        "5354561dce4795745c270f6471f4d3909e51574aac2622f927844dd756c89686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d31d88b9c6d90c0373b519e16e0633d9c2eb21fba143093fd04c9cd32823e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ec8310a3683abe236c6b4c90cd5fdf141e632e5a066fc3b5a0a5e3e4db97a3"
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
