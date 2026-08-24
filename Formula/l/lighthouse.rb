class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.2.2.tar.gz"
  sha256 "d7c2db0cfb18ad4748600b44c872714a1302b437cb8fd98ea42d4d311a0e3f8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b2647bb0c98201ee467e5908cbb70c9fcf7274a2fabe9f4650e777c4ed8a27f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a267a85d21783618b287962ed520c5ee8c095a7d6dbbce350115938fcce7f09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9db22729d6dcb6f6460077afae159b5653b6ab2410755d30dec3ed73f2bc39"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec8d6a540168f52fdaf8bc557cd5e8b3308f9681823e85a0ff410f5405a3ed90"
    sha256 cellar: :any,                 arm64_linux:   "644cfaab1283328169841955c493d01daae1bb1a2bc2c06900f956711b0b92b9"
    sha256 cellar: :any,                 x86_64_linux:  "99a1348b937b0e1499ee70a9317bfb733fd56120672247de78245756ad174d82"
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
