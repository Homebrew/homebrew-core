class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.125.1.tgz"
  sha256 "2db2ed847568f1e8f2f2391cb7cdfad901d20bf16a40f207933ad3c2ba0b49e9"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a19ac4da839942c8ec93b1ac8ca058e7ff90a7bbd1cf86e4c10c798f71b6bb75"
    sha256 cellar: :any, arm64_tahoe:       "cd2c07dac51238819838590e72e984629f02263732ee3abf44e16b2363ce21c6"
    sha256 cellar: :any, arm64_sequoia:     "fddb12e665e21f9d315bd435d0f362ba9648a2e6f3331f1d5a13cc676f28f1a2"
    sha256 cellar: :any, arm64_linux:       "300fd1b04277268966bd9522db102769b6f34db865d07769d100723bd88c27a6"
    sha256 cellar: :any, x86_64_linux:      "516b2b3c337cc97b666bd1cf6dce8a7aabced393c7b27b11145a3c6e2aaac936"
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
