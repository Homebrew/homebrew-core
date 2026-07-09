class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.11.tgz"
  sha256 "3b3165508391b82b38e62189979df589a45a2d8019a8ef7910fccc554649ce7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bee1393b57eb703a0773554514890c585e088174e3aa92bfa13bb5c22e1da425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee1393b57eb703a0773554514890c585e088174e3aa92bfa13bb5c22e1da425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bee1393b57eb703a0773554514890c585e088174e3aa92bfa13bb5c22e1da425"
    sha256 cellar: :any_skip_relocation, sonoma:        "7affd5aa8d3e8ad9f75c3154bc4d31e88b030ef3e40b575a901d795f11627902"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df95e770b9c00616c69b2cc7c9fc582b39dfde884d5dc3450a64c8e4a4ad5e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2075fd2441fc795854a96db0f422dc647428b6e663901771c71e75afa74267e"
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
