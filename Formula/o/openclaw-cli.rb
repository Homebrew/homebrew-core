class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.15.tgz"
  sha256 "8c95f77538130c77967c970da4744786c4d5b773937b8208f622efb4cf0d2564"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ea0a76c655a309a060e011714cceeb8d4e4f6e232001596b54216e1702299ec"
    sha256 cellar: :any,                 arm64_sequoia: "55f75f14c6809cab30e18d039ca233e2047982d91ac50e6f4278a51bcf31b83a"
    sha256 cellar: :any,                 arm64_sonoma:  "55f75f14c6809cab30e18d039ca233e2047982d91ac50e6f4278a51bcf31b83a"
    sha256 cellar: :any,                 sonoma:        "f9981584a63b9b474f56a44c633251f409a3d9706058845f47b10e48c110ed9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "483f69a0e30d5c9fc9c5fa38240ab26ac4c22de7e5e1aef0af69e6b4d2d8497c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f093cae342fc57330678e7466f8985cad3472b170ae9e18a33fe3d757a597f"
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
