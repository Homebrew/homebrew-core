class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.3.13.tgz"
  sha256 "6711d9f8c4f12bdbdcd5090e6865e2ee141b8cda3eaa8f20259304406a20e96a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be8a90d5f2d798aed2fe8146a8a853a6a0c6c2b34186b398f508c9934627d415"
    sha256 cellar: :any,                 arm64_sequoia: "7be934a43cf37e39a96ea254a4d7214b54c59b98a56534b7462e11e29e90c625"
    sha256 cellar: :any,                 arm64_sonoma:  "7be934a43cf37e39a96ea254a4d7214b54c59b98a56534b7462e11e29e90c625"
    sha256 cellar: :any,                 sonoma:        "5544a8a439f09bd4a764cb49e6478b4cdb018affaf55b4e430582ee600a6c5b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "272b1a5ba51b90b09240689ddc91f11652d062e9333aedeaa1e53b2bf2fdd653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3071511540604e105fd2a9a35adf450a1a168880f280b6fca96d424ed00aae6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # Remove incompatible pre-built @node-llama-cpp binaries (non-native
    # architectures and GPU variants requiring CUDA/Vulkan)
    os = OS.linux? ? "linux" : "mac"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?("#{os}-#{arch}") &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
