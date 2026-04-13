class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.4.tgz"
  sha256 "cbac9508feb538fc253133f3a9198f175b1b9cbe04333b470cfb276a14bdc4fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54b158aec30bd4bd1e83d1b887b63cc4e3f888c759904802094c6504fbd5d70e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10551f2ded5fa09d237d90b022da7cd6f347ca253d57f5e038ff1e841d449a15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f720a8a93631548bd335fe0a9ac0a6777c8ad31c358a573f1042d3e7f62790"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9b16cbb7aa2c5ddf348fbebad33351fd3dc29ac4d533de04890d12148ea86b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "129f2c81cbfbd851bcd1990a3ab0fa7eee0a42519c0c811bda545974e7628da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c87e48b1a5fbe63b43b68504cc745f2ff9fc9869433587291317a4ad9ad2674"
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
