class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.8.tgz"
  sha256 "7dc691946e8cc3db5115ee56fb23c6727af471706e749ef41305954932b6eec2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7299d793564ce47ab0a24348d9d407297f78e4469a549ae4e98481f9007d534"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6665edb9b3546cc25f9f8cd050a6325a1c3f9c18ea2e994ddc3905c2e532163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf2b9b9a705fa25fa0b18c8d17a3061d9549175e42f7e360befece925d7df4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "41435e3ff623c106b511071d056737f86012c78b3aea6c3db60394b19444733c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8ec1cac3232fdcd6cb4573c25b1ff53b874a124fe8355f9e93538553c7718d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c6ced135ce56bd765747b66c93018205a56afb707235d550bb2e7b78244af9b"
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
