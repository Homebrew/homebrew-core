class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.12.tgz"
  sha256 "03358db53df33d4ebbc983c42e267d88376cf95b71277d633ed1cc7d2c514813"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "172b0c00f87e51bb7316d3c4900c473c97dd585f2747341e2c0a4ddbd558ee87"
    sha256 cellar: :any,                 arm64_sequoia: "7f5f46c5b47fbc83fc723146034efc0e1bf53cc4c06fbce246fa73e281e2d6e8"
    sha256 cellar: :any,                 arm64_sonoma:  "d58eed871730e041deb155f93be5d9e3181a65d3f7c433e5734a435bfb713c93"
    sha256 cellar: :any,                 sonoma:        "f49ef7b9e8bcae90b0115e946a22cc0c49fccd2868afeb303edbd16bb529a13f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b20976186568b186efc16670ffe6e73cf57ad46caab62b84e7e9ebd7eaccf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55d2d3a1fbf05c8ddc699e74a56aac9576967fc551176c7de28c851a3c006fb"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
