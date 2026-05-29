class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.27.tgz"
  sha256 "cfdc32b25c9b097c47afed049ca38378c62e4508eaa6e4e82dd0f913164ea499"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ae1e8b46211b2e422c90b55a43013e7eaeb8514304d1fa4f4718fdfe0b73cfc"
    sha256 cellar: :any,                 arm64_sequoia: "29ab7dc8f748a950c6f35d935c450c5af397d24538c8c622b8b64e0706dfa3cb"
    sha256 cellar: :any,                 arm64_sonoma:  "29ab7dc8f748a950c6f35d935c450c5af397d24538c8c622b8b64e0706dfa3cb"
    sha256 cellar: :any,                 sonoma:        "2ac840454ee896f7449f95530a3056b152bfb48b3f86d9cf81dd0d39233e53c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1abf1069e673839cd20d7dca529115e8b7d95481bef152bffb1899efaa5f20a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fdd050e1fda712cea5494c8a54a98fe04b7bae7ccf1ed1b86eb0977252136cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules"
    pi_node_modules = node_modules/"@earendil-works/pi-coding-agent/node_modules"
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    pi_node_modules.glob("@mariozechner/*").each do |dir|
      rm_r(dir) unless dir.basename.to_s.start_with?("clipboard-#{os}-#{arch}")
      rm_r(dir) if OS.linux? && dir.basename.to_s.exclude?("gnu")
    end
    pi_node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}"
    end

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
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
