class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.1.2.tar.gz"
  sha256 "c1c51813968ea4f4372ea85a7c0a91eb261adc2d58d29847196e9467ffd6c8a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c919c043a057fbb95eedecfdc29486c4d92fae90cc1827653e94debd142cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df00c922c4477faf06c9e9a7d198be83804e80c35dabaf61be05958317a919bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "567ba1d775bad0541ac6b0061e81c061f10a2bdb2672372dea13997cfb5e52d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7687a489835c7f8a395acb69e4c3b17eea4d499b3d0a8d7226012881361babb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e540cfdb162e1822f042165e6b4bf8c046093829e06ec0e105b558e6bd0faab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67bbaa2541aadea92102ef643e6ff6dfb75e4c17d42923c31ebdd2bc2c7b189"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # fixing LLVM 22 builds, which got handled in https://github.com/sigp/xdelta3-rs/commit/fe3906605c87b6c0515bd7c8fc671f47875e3ccc
    inreplace "Cargo.toml", <<~OLD, <<~NEW
      xdelta3 = { git = "https://github.com/sigp/xdelta3-rs", rev = "4db64086bb02e9febb584ba93b9d16bb2ae3825a" }
    OLD
      xdelta3 = { git = "https://github.com/sigp/xdelta3-rs", rev = "fe3906605c87b6c0515bd7c8fc671f47875e3ccc" }
    NEW
    inreplace "Cargo.lock", <<~OLD, <<~NEW
      name = "xdelta3"
      version = "0.1.5"
      source = "git+https://github.com/sigp/xdelta3-rs?rev=4db64086bb02e9febb584ba93b9d16bb2ae3825a#4db64086bb02e9febb584ba93b9d16bb2ae3825a"
      dependencies = [
       "bindgen",
       "cc",
       "futures-io",
       "futures-util",
       "libc",
       "log",
       "rand 0.8.5",
      ]
    OLD
      name = "xdelta3"
      version = "0.1.5"
      source = "git+https://github.com/sigp/xdelta3-rs?rev=fe3906605c87b6c0515bd7c8fc671f47875e3ccc#fe3906605c87b6c0515bd7c8fc671f47875e3ccc"
      dependencies = [
       "bindgen 0.72.1",
       "cc",
       "futures-io",
       "futures-util",
       "libc",
       "log",
       "rand 0.9.2",
      ]
    NEW

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    (testpath/"jwt.hex").write <<~EOS
      d6a1572e2859ba87a707212f0cc9170f744849b08d7456fe86492cbf93807092
    EOS

    http_port = free_port
    args = [
      "--execution-endpoint", "http://localhost:8551",
      "--execution-jwt", "jwt.hex",
      "--allow-insecure-genesis-sync", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
