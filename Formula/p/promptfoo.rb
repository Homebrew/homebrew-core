class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.26.tgz"
  sha256 "2835ee7da76c4af2d1c938cbb41f932b1e84a1b838da59e3fd48b504d3b772bd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e15352c340a853fa79c592eae5d4c58ad48118f43b3cfad4784c682a1b383f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c59c027c6cef10cb97727089d2b022051c238be9387bc6cd815955940d9586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a798d0e25b95a7d50da08a44891b38f508f3fcb0a497641fc4c2ddd7be84c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "989f2c0427223662b41bba57751d89c98d44c75555c53cf9d472ad702be9e4f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b61644a4be24a8b66cdedfaf23723464bdfa78f9c978711f1e9a893abc6fd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4375f9c1d6ae5a875b1c2a67003dbaa077fe6ca9bb67cc84a69e881271cb4543"
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
