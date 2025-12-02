class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "10c2d76c190eb0d4c3c394c7994d011b083df4f8954f3b4df57b01b8cfd931cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4839e94e9bd9bc8d636ff38c45853a6f4dbf2e6716376f25e59ea26c664b18f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15726f628f348765c8abdf4867585a51baef6035eb4ad03e2806d7d662cae46b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3f863a8e788ccedb8fdd6ea205e9310087314b9a13cd5f100b8e8185ff388e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e76d7b7344af5d41281ee19ce9e0f7b37423a3b9947745db4b8ddc479f4031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba900cf12f49e6e312749562f8d2448569128cf337e3897f050ebbd7cec7ef73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6747580308dbdaa1263f906f35439e4d57fbd69edac97d18deed7d15cea6ec3"
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
