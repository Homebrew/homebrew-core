class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "2cfcd398812c31f9302b61e18cfa537c193268c7db5a96b57cb97c0bfcbd68c9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c359536d5fa3d1f9bd49f4b3fb94f52db63fb833d52e9b8797a760864d6b08d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95209fd3a6fd9ed268857e748f2c242ba3f36af660c7e4f3c3cd77128bbb12ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a6684c51048966e8e5822805b5f6b2501d6f1f6f3dde0e8cba44b495e838a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a183726f9c92a23e289c7921efe5fd7002f549f3e1f44c8c17f5e4a2995e34e"
    sha256 cellar: :any,                 arm64_linux:   "071333df7c613cb93755ae058d1d0dfb8bff62d915323ec0b1e2b2df670f7d12"
    sha256 cellar: :any,                 x86_64_linux:  "77e902e2a42b7afef15fdb63b516dd7910bbed2a30ef41e00a3b78113f9cd411"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "lighthouse")
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
      "--allow-insecure-genesis-sync", "--ignore-ws-check", "--http",
      "--http-port=#{http_port}", "--port=#{free_port}"
    ]
    spawn bin/"lighthouse", "beacon_node", *args
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
