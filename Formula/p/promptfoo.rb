class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.5.tgz"
  sha256 "dd4b97c0b8d3738ea2d9bc17fc433bb4e577b924a2d3d5a6508ce3fb40f0fd25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "146fb42970d43262ecef171a0d32b9730c3b6a7527c303e92977c10dd89599d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1355ee0dc87f69fadec41ca21043ffc8e34dd66248ad0baebfda4e1cae960710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75fb15d12cfea6d3918c97e63c072bcb952361990f17836658f6330e8ab9854c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3974db862641dd84947f3540bdf0d51273df84f162bb5a4b45469a69231f23d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8576e093a2700e9744c5c4ff902a5475c4768311480d6757e184ecf87743762c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a429820b9978faeb5e0a494920e185323433518f40b7753d82fc9de458f296"
  end

  depends_on "node"

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
