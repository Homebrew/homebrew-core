class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.6.1.tgz"
  sha256 "e43ec41fd810c147775baa42692a2eb110e5233abb67534901c727866369a4bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c2887984807e3930ad3420114eef714e3f80508b06ec9979246f65c036ee9ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2887984807e3930ad3420114eef714e3f80508b06ec9979246f65c036ee9ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c2887984807e3930ad3420114eef714e3f80508b06ec9979246f65c036ee9ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6a470bc0f017068a5ddd110ab3f38489f6c683eefd75b178a1f2298459d397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c011f5d0e3dc307712593e0cda6283d019310419c4638ab4c35725550294c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e375b1aed8089519afab4858e83d42feceff766bb0277078161a056e43f6f631"
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
