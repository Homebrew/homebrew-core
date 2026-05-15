class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.7.tgz"
  sha256 "1fe195d8e3928062cfaf7f9ef616670cde25b35ea9631fcae5f8aaf8be2986fd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18d72a7054a4156aaceaa22da6ccdc07e4afecd097b31c8f62a9da77a3808fc1"
    sha256 cellar: :any,                 arm64_sequoia: "e49f68b1d35068e17aa94227e8355f72c3aafb8bd903a9744d163660ba38d3a7"
    sha256 cellar: :any,                 arm64_sonoma:  "e49f68b1d35068e17aa94227e8355f72c3aafb8bd903a9744d163660ba38d3a7"
    sha256 cellar: :any,                 sonoma:        "85863f35058a74352299283cd54bc0226ae9e3ca905e4c4276af66b89e88b6de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cfa369d159d6fa10feb9539633f0b21fd81ea4904603b5be867d15140837f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29bea2b13de3ea359737ac5118bb96f8c260c1dbdc49acd9073d3c3ebcd84c5"
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
