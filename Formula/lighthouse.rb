class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "191dd902f8d4f1d67d3edf4b3af808fddefaa5d85a83da2d8f6268306331bcfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95cfa93c0f49106b6522f9ce7ca0bbd726006f571a7f2f87ef4978a79486b359"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d2971b02471348df20b64445a2e15fd960dc419d546512522eec870c4c95cec"
    sha256 cellar: :any_skip_relocation, monterey:       "6939bbed1598f7c40b0dcc187597acfc4e8f95297cca77b67f886dc768d4830d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4040268a7f5d01f2800624d77f60445a6e77df9ee1d4465ad7ad22f58c9a547b"
    sha256 cellar: :any_skip_relocation, catalina:       "f9f288869faeb5883963ef2b59ebeea192631483336f7096e59ab8e35fd7c508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3d6381ae98857bf6f1f540407d8c42a9f14baa39a1449ec29ce5abb6207491"
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
