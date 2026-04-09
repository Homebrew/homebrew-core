class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.3.tgz"
  sha256 "715a58483df1bbd174e2bc31e0b069c83c1bba25563c8adfba5796b2e161c7a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd9e520d3bea79b2466e0da61d033ac143d8715afd66bcb53ad167077daeb14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072c955e8096ae9b9212cec0de15fe24d6a49a191c0dd34262ffbe31d29737ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b99405c799ca131470ca67d15277d64ea3328abb940f6de6984adaf2bbea9daa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e35a4843f880d27efdb51c4092f5176402e4909a2860d96c47973c7378680c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96a8c446539bebdc6de898fe8ab2d58d5cb011a0504ab64fdc456bb09e877b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b82ba8ecec4cf6c5017fe6c49aa71031ec235d200d3b219d782872b47afd1c"
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
