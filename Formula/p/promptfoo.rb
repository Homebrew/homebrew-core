class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.9.tgz"
  sha256 "3d16dd0c00a8acc47cb3f6177c487639df9355e69dd1abb2946ece9660240e1d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1f1fda3c5335c87e7b9ee25566dccd216dc81e89309e87b8a417c945fc9e7bad"
    sha256 cellar: :any,                 arm64_sequoia: "b1cd922f948fc28530fb81a38da59b5c3884edb3c14409b360e9d910f19915e2"
    sha256 cellar: :any,                 arm64_sonoma:  "8b7fd8f0dcfb1a59f399f88a6a13cc30f618a1474ab4fac9aef52bb05f3fab28"
    sha256 cellar: :any,                 sonoma:        "196d6cb2e7e9d8a5571425bbf739da59b92e08230e26215eb60eba46c09b1b72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa801d0b2078334ea5b3a9ee8af14e37edc0f91b23088400d34395fe2a1ac6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30685ed592d38196ecbb862b2b112ce5101c0d9c741ace6bd31eab1678ae0c3"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    # Allow newer better-sqlite
    # Backport of https://github.com/promptfoo/promptfoo/commit/9c70bbf438f65e38d7a026d8c42d63272c6ef801
    inreplace "package.json", '"better-sqlite3": "12.4.1"', '"better-sqlite3": "12.4.6"'
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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
