class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.14.tgz"
  sha256 "74a29cd27ec9345b99a24544c5f73978a9dfcc74c039f4bb7cd7310e99504402"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1212f87b08c660cdfb11902104cf12d099d11cb6eb8b0a8edeb4167634f1110"
    sha256 cellar: :any,                 arm64_sequoia: "319d856466ea68175d6ff81d32014e15d4c60d49138df0d6b7a7e7b042caba66"
    sha256 cellar: :any,                 arm64_sonoma:  "1d39c0da2f4baf522aa17a25fa9f3c12438bede035105a64ceb4b7e6fe699bf5"
    sha256 cellar: :any,                 sonoma:        "fdbebf411abcfa655a7c3f575baa0e45163afd5cd13f8926920c780af5a67eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3380e5e94db3474686aad086d82049f9c8065e018d041b3672589864d4a69d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfe06e030bde87b549968d55dca8e4f3d9a95c5d7bb529dfdfda966dd848bc8"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    os = OS.mac? ? "apple-darwin" : "unknown-linux-musl"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    rm_r(node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep")
    codex_vendor = node_modules/"@openai/codex-sdk/vendor"
    codex_vendor.children.each { |dir| rm_r dir if dir.basename.to_s != "#{arch}-#{os}" }
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
