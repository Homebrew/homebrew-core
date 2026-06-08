class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.15.tgz"
  sha256 "6b871dd757ed9b3fe5fa1bd469056d400a47ce0bff8fa57c297390429a98b05e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa7cd16e430a0a47cea0b3e2c3d32ffa3d7793f866e5279d6a721db0ac0f21b7"
    sha256 cellar: :any, arm64_sequoia: "ea7803f83c6f2456c2c63911e30f4ae83448b4771db781ac808715308899c5a6"
    sha256 cellar: :any, arm64_sonoma:  "8d1e1a2af8c89c8de09e60ec0fa8463df77b8dcade278bb91896324a41816c97"
    sha256 cellar: :any, sonoma:        "92a4c7f1365c3c1664bfa57c273f961bccc011d3a3767ad5caea3614f4b3b48a"
    sha256 cellar: :any, arm64_linux:   "60a365dde97bcc88e2456b1f61efb9c82bab1f11b95b7abf1411edfc2ce1624f"
    sha256 cellar: :any, x86_64_linux:  "a67fab155db6e903295ca8bd64d3a56d8524c0dea111e11f3e32794da05d1064"
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
