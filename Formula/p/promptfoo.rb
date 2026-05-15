class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.11.tgz"
  sha256 "094bcc44d03bb9224d0c7b8d02a01cfe0b7fdf937e0e314936596c483c9bd665"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24bb523292e3f1c768aa87189bca8d70c33a0b5392b2bd9f31a0f4596990e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e211c06d1b2b40ce347e978550d2a49a7a22b8d34b574a869c13f7ca862be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "919991735ccb3f237b7d193150e73d803b6d47efb9da8799e399ef881d6f30a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0f2e82ac25be2d19130a83c4444d3b2d4cde81437d3186ca77dbddb7d88c7aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "740c7dff09131a8a0310ed069003aaebc284b0c7368c50c4fc4a2e61086b9007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a862705313e72778264e8572d6bdf0e73f2ab2a7949173fde5c486ee06dfbc35"
  end

  depends_on "node@24"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  fails_with :clang do
    build 1699
    cause "better-sqlite3 fails to build"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)
      system "npm", "run", "--prefix=node_modules/better-sqlite3", "build-release"
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
