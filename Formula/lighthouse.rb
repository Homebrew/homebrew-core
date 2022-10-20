class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "7fc8b408d5319cb7cf80257a5a8daa38677f2798452e236f299d219d57730993"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fcd99a934150eefb24ae46277f59217dc4a9c20f9e184e1d9fd9736fe4e47b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28050ab27f7f61d83ac785bab5deebf25308db241a0d1e213400605c9af10ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ecb8bdf0f9bb8803a96449955253992a1840139a69883e098ab323a156814d"
    sha256 cellar: :any_skip_relocation, big_sur:        "69ba9d3e45be0982103d8e428e62eca4566f4f6611980d45175831f040399270"
    sha256 cellar: :any_skip_relocation, catalina:       "a63e8f26756f270bb9ce91144fd7edfa9300456f13426aeb9dad06da63fcb93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1de8685a55d15b949c9ced3017111126449288251713c3b7f772ddf4f0c2a413"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
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
