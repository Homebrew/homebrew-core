class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "0353545166093ecdc572532e71f3e5dc60a582e9976b5c3129bdb9212e82509c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "042dd7aebe943b1b6d81231cea9bb516bcc41c2c811b2996a345b72dda2c34b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc8aa74e7429c013379012a9703aed543d15163c3ea82ef95044d11fdea45fa6"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb6f8c096b2c6dff57dee662afb9163dc90421c1aafa49a06967f26bf9195b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "caf2248537e47ebacc8a2a0ff8fc474c8f0ee3676f0c6045df9d2cc3089579ef"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a330995cd01d3c48e27009684c43418ff6ebe481c86c055ebb4d683a57dbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d587fda4acc0ce1f0eb72f44f5451d0b24d79f1c85301ba24b73bb1b4324fb27"
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
