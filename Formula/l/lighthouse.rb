class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v8.3.3.tar.gz"
  sha256 "f0e693996e08bf3dc738bc96be76751140906b8e0cb3ac0215e5a3a95ce01c0c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cf12b361ef3c6726e77a7b85cca8d0e09b921bb65acbac5817faa9534a645ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "478c46b174a2f49b009aa298600689e74ee471040cafc53ad1b794068efe56bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c58e0f71fb9dbec43759cc4f43ba7f6b67986a8443e46d0ea48bf6724af09c4a"
    sha256 cellar: :any,                 arm64_linux:       "db4eccc91d59207432b617235cf9917f23e43f198f97fb2c53e80aa7d578d2c5"
    sha256 cellar: :any,                 x86_64_linux:      "edc3dd31c7bbb148cc96cbfde809337e4b3bf8aeed3e9e2b5fc13b937b0f046a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"

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
