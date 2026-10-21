class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.124.1.tgz"
  sha256 "be3fe4dd4cd78e61a2fc81a8bcaaad1c8f29b63ebed16f08e629a5856f0c270f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "27e2a7bcbaf490f44e0425e36f2b2d033beb40df284d40fabdd793855590ae7f"
    sha256 cellar: :any, arm64_tahoe:       "f4af3bb74839a01b962bee63ca95a68f627bfa1e8544c48f37bf391e4d1f4fbf"
    sha256 cellar: :any, arm64_sequoia:     "082bf000c14e3b79015410b90b2cd9eb78e25767a054ed3ee0885c0e0f871f40"
    sha256 cellar: :any, arm64_linux:       "689c853a0deb58ecdd9386305e701f32dc81ef35411b6434828e2191b34f60d9"
    sha256 cellar: :any, x86_64_linux:      "a235ba8cceda33a6ab9d094437c3c1a63a0f3d738db1eb7ae9108c33a7a3d58e"
  end

  depends_on "cmake" => :build # for `libsql-js` > `libsql-ffi`
  depends_on "rust" => :build # for `libsql-js`
  depends_on "node"

  resource "libsql-js" do
    url "https://github.com/tursodatabase/libsql-js/archive/refs/tags/v0.5.29.tar.gz"
    sha256 "e7ccf7f0ade06158bac3f5fffe69d9707741940678aadec75319713e21b57c21"
  end

  def install
    # NOTE: We need to disable optional dependencies to avoid proprietary @anthropic-ai/claude-agent-sdk;
    # however, npm global install seems to ignore `--omit` flags. To work around this, we perform a local
    # install and then symlink it using `brew link`.
    (libexec/"promptfoo").install buildpath.children
    cd libexec/"promptfoo" do
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
