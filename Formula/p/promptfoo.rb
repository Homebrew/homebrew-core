class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.121.17.tgz"
  sha256 "8b0d11a60faddd0e324857d175fec2b6cf1907f25ca3b272163d4a25b2f0cd09"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aabfab46403565ba279698cc08c803397d9d6642ed80a6ddfedf1c87c31c1d36"
    sha256 cellar: :any, arm64_sequoia: "bffedfd990d1bc06ab1969cb55768d0956b0e55b40c7c432469b5e17b0a9ac5d"
    sha256 cellar: :any, arm64_sonoma:  "78ef11e897082a2fc626899495df2adc687c4ffafe7158700ecd5b8ff56c9b39"
    sha256 cellar: :any, sonoma:        "762e33ae9299379aa11db61afed0421f5721fe6001843966ead05389a2191691"
    sha256 cellar: :any, arm64_linux:   "fba1f5fd81e135cbb46092b523b618597ea5dedb4e299bf337ebbea5b25ad00a"
    sha256 cellar: :any, x86_64_linux:  "d4125df4fbcd1d0536f40be8676524ee57b01431b4479499d353f6fa870ce186"
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
