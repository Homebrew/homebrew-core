class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.19.tgz"
  sha256 "ce1f3dba80c08797e39ec946aa1fcdb1921182abb8f8f39085af90b6079e7aa4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a18de9f940ecef471971a5502e760ec67896843e52ca8b2a5776665f732bfc13"
    sha256 cellar: :any, arm64_sequoia: "41ba4bfaf42214d87a6afdd5b0e749c3fc55c4244ac433a197bdaa08916dd753"
    sha256 cellar: :any, arm64_sonoma:  "fd7c93fc2c3473f942af6d7fe7add8f88a0d9803f7d3b34b33372e423f5a7033"
    sha256 cellar: :any, sonoma:        "544b7507cdaa7269b0261ba474b71ea12d8449dea1952752e308a9d0ea08eb2b"
    sha256 cellar: :any, arm64_linux:   "8d9ac18061f87c2be1fbc014cb043889d1079b071f96cb878640a90686b7ffbd"
    sha256 cellar: :any, x86_64_linux:  "2556752127925828c7d8d2dd70957ac690aa40777826c54f1d997563f8756740"
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
