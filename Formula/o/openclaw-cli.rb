class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.2.tgz"
  sha256 "f0efe516eb29ac04d07985d974061f381b1ff0374ba3cfb0caf15209bbfea130"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d5d8ec366c12ac2c23d89d7f8b0399fde63498c59aabe728ebb339378588506"
    sha256 cellar: :any,                 arm64_sequoia: "2a47cac0540d74326da2745f94b0571deef7d685f9ad2dc632d4f0ecad451d78"
    sha256 cellar: :any,                 arm64_sonoma:  "2a47cac0540d74326da2745f94b0571deef7d685f9ad2dc632d4f0ecad451d78"
    sha256 cellar: :any,                 sonoma:        "e5540a927fa6f83d998c303e2378d47ab433972eed68449fb357a1feb44d9d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94adbad0e64537779dcb25db9f10ef4756d67009710853a012b395332059b548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27335c8a1b00d040a782cf4154402722a6640e0c0546c5f72d256d4e45ac6743"
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
