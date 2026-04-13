class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.11.tgz"
  sha256 "95fdabf7a4cfdd2cff5490eff3a237efc63f95ba9b971c9eba40e067115bc0e6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52f3139028a25b89b5a42db36c1725cbfef474f09475978643bec423c8fb38ab"
    sha256 cellar: :any,                 arm64_sequoia: "b7ea031714bd19f296653fd7dd23b6fefcd30a2ca97c9c38bb116d2250fbb8eb"
    sha256 cellar: :any,                 arm64_sonoma:  "b7ea031714bd19f296653fd7dd23b6fefcd30a2ca97c9c38bb116d2250fbb8eb"
    sha256 cellar: :any,                 sonoma:        "9e14b7d7f5b01668ceb1c6465f80123dc10c1c97367d36e6f66374629f0f0161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91ab919daf8da63f43d198b636388ca3e7ae90f79c48b37c5127d642b5a0a194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45bbff54c0e2b0b75098f709ed3786623a976f34a667130f0cfd442de6a7d735"
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
