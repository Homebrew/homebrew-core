class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.123.1.tgz"
  sha256 "53471b239132b5e7a270fda458f78a1f1b920abb617ef4dc2b096608d480ee2f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "083eb844985cd1bc6889784b7b4bc8a147e019c38997a3271baf4af4715bee27"
    sha256 cellar: :any, arm64_tahoe:       "b695a9e218d36c475851d67ce0d96221af1c6e7abba01408b4d8e3fad6e60574"
    sha256 cellar: :any, arm64_sequoia:     "e7415864a7576656ac440d98261fcfdcf4301227ff1c988adebb45c05ca3c0b2"
    sha256 cellar: :any, arm64_linux:       "ceeca01f4af803371c4bad2d9d5ac0188d5001df9d0cb2e5c9ea30d05e8dc22b"
    sha256 cellar: :any, x86_64_linux:      "04608af224adec44674776d90380efc94f612589dee75132d1d2d11950b3da6e"
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
