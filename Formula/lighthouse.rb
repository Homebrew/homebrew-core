class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "ee0861dd492a22ca547cfbd8cf89595652ab8e8270f6bad3afdfe0f7da4d9d2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2111197c2266f552af591d788155b6ef0a3728b12a94c4df978006666d20e5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fce6d7cabae44dd4457f74a044af42748d894b26135b01f1a6c9f41ecf2a7c9"
    sha256 cellar: :any_skip_relocation, monterey:       "76eb7e2a5630b23bd6ac4ec01afa1f22ac6cd7aac07853e189f8ba26512e584f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6b0956a99ca82c49b198be69c2401edd6434f539371a3394a3228f913a2d18c"
    sha256 cellar: :any_skip_relocation, catalina:       "950e25954c6114d2705fcdbede5ec9afcd8aba02f77c2e50bd0af35eb50478e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c73c6813666d4020c59f10f821ce0dd158d778e8860e5f714b9d8ea600e55b"
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
