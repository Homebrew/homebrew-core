class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.0.tgz"
  sha256 "0ce4000d1d5440fb9fbb52c2b113844bd2f9bcbfc39abbf6482388e0be6a44d1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea8452d90668576e46f11c574e2b5fcfbfdc3ceb62e34de197c18d38f868d114"
    sha256 cellar: :any,                 arm64_sequoia: "69b4dfd01585794430789b0ede406061a0e1c49bb929ccca9b7033c91f723866"
    sha256 cellar: :any,                 arm64_sonoma:  "a7952c77db88de723fb25fc8d85d60bd33d3e8a02e42977239b6b93587796bb7"
    sha256 cellar: :any,                 sonoma:        "a0cd8ff5b38a4d4aff6ac608e0604b5da5a914e5054078cc6bf30c2336621ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31b922f87c2ef70caf6ec7f2b862471ba41c2dec4107c2123ed1f77524e68a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca795453812af80739bfea1acf9aee33d8277de613529a6768c0737fd68fb5b9"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
