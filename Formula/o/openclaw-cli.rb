class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.2.17.tgz"
  sha256 "42e083bfa6ba27b5ca5ceff256d26396542b7f5c4ba41fa5fef3b8387d2aa811"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1cbb10e48feaaaf2b2f5b69de3707c43456204357d7946872ff65d000ee1d993"
    sha256 cellar: :any,                 arm64_sequoia: "cbdf0d6ffdc05e147cee4398f920d51dbba799a5b6c6160bfb82d283deabdcb6"
    sha256 cellar: :any,                 arm64_sonoma:  "cbdf0d6ffdc05e147cee4398f920d51dbba799a5b6c6160bfb82d283deabdcb6"
    sha256 cellar: :any,                 sonoma:        "00708d796daade0dedc01c5eb51e8a42424e29878a4ec7aea9aaf10f0ea7e290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db20cca50d324b234ce1c06b2bf9d4ee1c6534147809a224eb391217a0c24053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801d372cefd7416b3a83a43d926f662f284823ba2b370eca144238688752afa8"
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
