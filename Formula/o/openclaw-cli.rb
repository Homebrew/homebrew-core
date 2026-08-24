class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.7.1.tgz"
  sha256 "67ad539d9915efb63d5f294beeb9290b7172d23c92d8052110a9c8355f783458"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04da09dcbc375b4e113d644f448c158a1fc614446a2d324aad7b00b0a750bff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04da09dcbc375b4e113d644f448c158a1fc614446a2d324aad7b00b0a750bff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04da09dcbc375b4e113d644f448c158a1fc614446a2d324aad7b00b0a750bff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a3fe26f2da8d2bcab43d14506656039072393d3e9dbca97d68dcbd7175c9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6584686661bce1f490ee37d6d713719204463d584cd316eb2dd1f50b62fcb353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe179e303cc968e587e8a429a2f2317049d06e768e1ee225e4af54511b5615af"
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
