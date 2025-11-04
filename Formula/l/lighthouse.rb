class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "a52c74fbdab1406618320ebfc145c23e8b63eb2b69ae922d8649534da05b4812"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2db4b9b652c643e3949f7a9b48caed7b86aac7005d8264b463fb29cf47b85ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff44c1f41fb72740f277f3f5902f2112964c7a03ba2cf2621f2eda175fcb389a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61a474a1bef0983b62141052053177e954b70c464a697d4a3d786e0c7cb26e69"
    sha256 cellar: :any_skip_relocation, sonoma:        "438f57fefd97a2dcdd92532652dc8f8a60856edb4223a2a5912ff1335dd7f3ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4d9b2aedebf1dfd856255225c4604a2541c965639500201782ebae5f48dfbba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03be3b7f94fa76deebfd25620cfc5ce88d66cc297ef38fab960a10055ea47d83"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
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
