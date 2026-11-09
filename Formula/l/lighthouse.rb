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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6616a49c8c67487a8897a8de4004a3e81ee36ff01c18486d4b22bc2d723a7c64"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d17e60557e24a793fb98b82073ee59382227dc1b6f9253235504be20c9ddd30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "482d0d0f52be6ea27302eb5a57665dd206c477aab4a1bc3e4b01175a69964a2e"
    sha256 cellar: :any,                 arm64_linux:       "27d80a84cb988f89a8b9629c9998e62dac49b30d941274fd1981613d00e862be"
    sha256 cellar: :any,                 x86_64_linux:      "19a64910051b64d22511941c5b7423e9cfd617bcdbf5a0d5f7ad6cdbea86d7cd"
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
