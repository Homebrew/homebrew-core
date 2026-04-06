class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.4.5.tgz"
  sha256 "df1e57a5f95b6968f5ac0bdcafc5f970178c04f4af85779a50ca88487743d0d5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56da681b35e6618252af5e130f741c61e2c7a53ffdb03c486abc384f8d400385"
    sha256 cellar: :any,                 arm64_sequoia: "7fb73fcfb2582ed2d9176b6ef1646c0d76f988379fe5acf8fdc32e215ce47092"
    sha256 cellar: :any,                 arm64_sonoma:  "7fb73fcfb2582ed2d9176b6ef1646c0d76f988379fe5acf8fdc32e215ce47092"
    sha256 cellar: :any,                 sonoma:        "7a933d61ed665521550319989ae9ee67d256125f78ec3cf16682e0ce06a8ae56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c07eecdc4f902f542c145f95412498cb3c5a77edbcd7d36b90e46703470a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca66af606c0962bc8e4d6bbef6606d6968e150ad62e9c0cd1f8eeee07b4620ad"
  end

  depends_on "node"

  def install
    # openclaw promotes bundled extension runtime dependencies in postinstall.
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove x86_64 Linux pre-built binaries on incompatible platforms.
    if !OS.linux? || !Hardware::CPU.intel?
      rm_r libexec/"lib/node_modules/openclaw/dist/extensions/discord/node_modules/@snazzah/davey-linux-x64-gnu"
    end

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
