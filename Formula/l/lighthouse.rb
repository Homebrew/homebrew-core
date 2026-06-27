class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "f36097bd9f7db9b3d6dda1c987c9ffe43cd05cd2cb17429f7523e9fe66e7f51a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e8170230f3f8669b0b1c0e54bd6491380c150cf04d9b63fb2d3218462e7754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ebf6e4c817e821b998517ad75eeed556833373dd2a67c3195e6d954d9e10e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9e30257e52bb5ef3187e40b1bcebe9d9e76abe955bc8dd4078fa9d0d09b26f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a647bc05d2b919289613d86bb32e3510198de7c67d06e056e960343da8feffa2"
    sha256 cellar: :any,                 arm64_linux:   "d0686a12a9b5fdd5a6c3396734f0c0a22d5e8290f32bd2fd98763cb7063e8b56"
    sha256 cellar: :any,                 x86_64_linux:  "08dfebd33a56aa8f7d99e1ed80b03e22496aab4432033092720fe4041c5734df"
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
