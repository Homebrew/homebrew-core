class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://lighthouse.sigmaprime.io/"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "9605b9fae17c2f042f9210d4a6ec10f071a0bae4d13f8caf0cf05027319cd956"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15119129453ec143c06419d33d3ddc761d483e53af86ecaf1dd23067a7a9a9d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b7a7432a417989c8dc1094577db43ae058b357537f6c2b324b50f54fcdb8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e91b821e5124994f950bb1adbad89033111ae2273427fe5d418fe3c8b83edaa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "931db41ffda20e5bd430e7443499b6e8ad131bf52acc1cc6437e36d4666be586"
    sha256 cellar: :any_skip_relocation, ventura:        "3888a833edea50b705bef762845379fea189177e2322da42766010b9f9291c77"
    sha256 cellar: :any_skip_relocation, monterey:       "218fa182a9a0b4ff14c0dceb644537114eef943d5d97bcd303e001df10d838ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec4a80076e6369afedcaed1be6307c53dd2b10dfc0fc5f5e2146ec9527ab4fe"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node",
           "--http", "--http-port=#{http_port}", "--port=#{free_port}", "--allow-insecure-genesis-sync"
    end
    sleep 18

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
