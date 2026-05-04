class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.2.tgz"
  sha256 "f0efe516eb29ac04d07985d974061f381b1ff0374ba3cfb0caf15209bbfea130"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d8d678ceca7f9822a54c66f2f2ef9617226592f682b5703fbf2845ef6559647"
    sha256 cellar: :any,                 arm64_sequoia: "0d0e782a43f84b0d8a153e3307d2fce55da854891449038fa03f9b6048ca75d2"
    sha256 cellar: :any,                 arm64_sonoma:  "0d0e782a43f84b0d8a153e3307d2fce55da854891449038fa03f9b6048ca75d2"
    sha256 cellar: :any,                 sonoma:        "3a49b650758a8bac7c78743c5f77dedb29125b5fb1592c1867efda2bf8572cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233a7f793771cc282095ec4de81f1b53444432dd26b39b43cd9f86e22ea0f38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6319255a314df364460b8c7f93ff37a0ededef6d9d09c9d2ea611685e07dbb0"
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
