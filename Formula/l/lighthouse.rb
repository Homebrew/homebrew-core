class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "427bab4f400967711f172f2858ce21db365babd82812cccedd30f01cc9cbf830"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75acd27820e92a7159497bac26119b2bbf4ce24bfd5d05768c81f4ed961e07f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b87d64fbbdd48fd7ce3d3c15a25b2b56c87f7e5234d8303e8c7a061e11b55ce3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0685c616147f4298d3970366d7d7fe45523c8982a85590a6613a78ec5aaffb61"
    sha256 cellar: :any_skip_relocation, sonoma:        "7765689ba2c89428b4a5e043b5d1536b81dbb42541fd4dce6c2c355e493e3c4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c17883fa73e5042943f40a0838c65b07ff91479a563bc854166d83877723f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725fe63ee9b6b0217185a7125341ae70d7f0ee0b47bf746f4698ebfb1221df62"
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
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

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
