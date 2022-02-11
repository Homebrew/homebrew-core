class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "eeb96b6eb23d61b7eba004c4ede8b3238afa4798cb0788af5511d12409bc971a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2834155e6520c697b58a27da27f7cf2729c301832df1b087ee328068a2ca066"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15a3e92173a3b262e282225caefe3db8e20cc8db2c0f391657b4c3ec545607d0"
    sha256 cellar: :any_skip_relocation, monterey:       "96beb6c6e3d17685025065307cbd9b21926e0a99312232b580658cdf41be8744"
    sha256 cellar: :any_skip_relocation, big_sur:        "52384ced9451f10e2658b179e71a11f0586d8987499d889731c14151b49a88fb"
    sha256 cellar: :any_skip_relocation, catalina:       "182aa62fb0196a285e7600358fe29b59faedba54c5427f21f4cb97884c3fd90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf23495555201d5a998fdf0ee2712e3d564d4c94affe1312d17cf6c2d303455"
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
