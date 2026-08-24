class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.122.0.tgz"
  sha256 "5a4d0821d1e2ec5cd72f3eac724ce292df80e4de84214a648791a57423b15c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df8d55144b439a5fdea2934d3155f690af4ea235ce786f378f07ce7fbb8baf4f"
    sha256 cellar: :any, arm64_sequoia: "8b6a5f1b6286e94d2871a955acb491c35362ecea63aac38441d71730cc94b91b"
    sha256 cellar: :any, arm64_sonoma:  "aa82c3c90992262bff92ba6f5428b1f3af601b932ac1a856134c9172033cd4b5"
    sha256 cellar: :any, sonoma:        "867e8a68ff0d0c38aa60a398ea76bd37bac40c4396b87b8aea4abc7365c9335c"
    sha256 cellar: :any, arm64_linux:   "156ebeca9dded9296ab38ab2aaf3a838882f3f707fbf5489c86be1032e22a516"
    sha256 cellar: :any, x86_64_linux:  "bc3b1126d27a944deec4a916415b7a59591745750bafb04be93bb1d57263c6d0"
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
