class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.9.tgz"
  sha256 "3ed21092bece051fb7450614c648cfff7a54ff622f150f26de19c5c7f1fadbb4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88b2fa0b7d68786833b6a2ad9c28fa622a097a17c6a3b45b42aa859a2f4668ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c1a097678f49b6270ce80fbe4871d087ef43b7a986d693820c1f433d75487a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291d1bc8f4e8331ed08e9e69df7b6252028c5fa276cfae21fb49f04863a47512"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4aa480a697f5dcfc5e256631bcda845803d2689994cd623cf27362db49080ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16bc17c8797230f3325c4d3b58ffea5f6b0c20d07896f0a837699c9e479cf6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dacfd958a9308086dbfd29af1b0d55339fe9070890fedf0fcdfde5182ca6e95"
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
