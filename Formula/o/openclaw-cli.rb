class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.10.tgz"
  sha256 "263d6b0d7f5fa6f772e58e3413979484549540397722dd51230d8522e94e3202"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cf238ba2a9e162b0850dd88e054988c75d955498c7d0e687cf6777a3b075e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf238ba2a9e162b0850dd88e054988c75d955498c7d0e687cf6777a3b075e1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cf238ba2a9e162b0850dd88e054988c75d955498c7d0e687cf6777a3b075e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "069fdc5901d89f91d5111eca07275ff702439c694fbd6247a008322b495f40d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "966539fdd330240ce23cb1cb432fe430252987e8b2e89a0bb19ddee7106723fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08fc83687541fa9e5225c2b7b5ae4751eb03354e2c7fddcc90ed561aebb8ca86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"

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

    os = OS.kernel_name.downcase
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
