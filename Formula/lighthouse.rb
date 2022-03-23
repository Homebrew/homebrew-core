class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "b8cb866dd321b262b23e00ab1e89fccaece233ca9812c97c46a40356368b3266"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c9f9bad4234150d442aac6692c50caffbb30843ef08c66611a363d6ec608e50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8ebf2344b6d3657a90e15c88afb250a5598b521138706496a2e330b749a0330"
    sha256 cellar: :any_skip_relocation, monterey:       "4154937bfe45f5adc827303719718128e79879ad06db232b0a7c96836738f368"
    sha256 cellar: :any_skip_relocation, big_sur:        "f46daa88ad4fb33543e182dfa3ed3de3ddb134689420fb543ccc44040547f806"
    sha256 cellar: :any_skip_relocation, catalina:       "a33e227d41e83570e3de4d33d7fa3bc3cd3d95a59806577fa4b160e1caeca70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03f7fe868f6718c2d0427341804ad11bbe42afb39a0ea5826956474605de06f6"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "./lighthouse")
  end

  test do
    assert_match "Lighthouse", shell_output("#{bin}/lighthouse --version")

    http_port = free_port
    fork do
      exec bin/"lighthouse", "beacon_node", "--http", "--http-port=#{http_port}", "--port=#{free_port}"
    end
    sleep 10

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{http_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
