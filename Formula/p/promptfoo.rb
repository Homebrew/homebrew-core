class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.126.0.tgz"
  sha256 "2dac1d087ced6e44e753c666952bdb2df9b456688bdc5a8fbfe6c1acf4159272"
  license "MIT"

  bottle do
    manifest_sha256 "4f427c432c4af4ceceeb8ce9efaff6c47dd329e583fd1b1c8ab98505335e6af2"
    sha256 cellar: :any, arm64_golden_gate: "e25fa367050f3449cb2c15da085758e7af0d63a63fdad4fb865a036e7e275074"
    sha256 cellar: :any, arm64_tahoe:       "014b175caeff6515576c6e9e3c0268f18694e63a3006a33c229aae53f9f8545d"
    sha256 cellar: :any, arm64_sequoia:     "74661dc1303b4cd01f41ffd2e3cc0b1855dc5758cceeb50df00463e221982805"
    sha256 cellar: :any, arm64_linux:       "68d37d6f4cb28276fce9187028753ed67438ecb0031f1178d759179f9b224dfb"
    sha256 cellar: :any, x86_64_linux:      "8b5ea8f4d42df05bf1ae9fa850ad712b2b332546661294ddb1a141788ba26782"
  end

  depends_on "cmake" => :build # for `libsql-js` > `libsql-ffi`
  depends_on "rust" => :build # for `libsql-js`
  depends_on "node"

  resource "libsql-js" do
    url "https://github.com/tursodatabase/libsql-js/archive/refs/tags/v0.5.29.tar.gz"
    sha256 "e7ccf7f0ade06158bac3f5fffe69d9707741940678aadec75319713e21b57c21"

    livecheck do
      url :url
      regex(/^v?(\d+(:?\.\d+)+)$/i)
    end
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
      # openai 7.41+ declares a `google-auth-library <11` peer that conflicts with promptfoo's `^11`
      inreplace "package.json", '"openai": "^7.20.0"', '"openai": "7.40.0"'
      system "npm", "install", "--omit=dev", "--omit=optional", *std_npm_args(prefix: false)

      resource("libsql-js").stage do
        ENV.append_to_rustflags "--cfg tokio_unstable"
        system "cargo", "build", "--lib", "--release"

        arch = Hardware::CPU.arm? ? "arm64" : "x64"
        libsql_target = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"
        binding_dir = libexec/"promptfoo/node_modules/@libsql/#{libsql_target}"

        binding_dir.install "target/release/#{shared_library("liblibsql_js")}" => "index.node"
      end

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
