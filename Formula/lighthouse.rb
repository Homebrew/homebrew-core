class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "1a7478361fb5116fdbf1b65eb209469448cf363279b718c0e5d7e5400b4abcad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9421170c4428c5a4783588e127471310bcd570d0fbbce1ea0955f5a4e5f47aba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98fa91cd639a01850ea34043e5c5d43e23e9630b9c641abb839dcc14af0efec7"
    sha256 cellar: :any_skip_relocation, monterey:       "8b7a6d835b0ae61dc19186773fe073315a2b85503df3c4fecbca970442910404"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca292fbb0dfdb7351bbfbaa33c2b35a94aa2a04fb8bae1d8409d38aa63e2e5df"
    sha256 cellar: :any_skip_relocation, catalina:       "54eb44ac7047bde21c426a0359ad9525e67a049a86923f0a9f535b7b1b6acb2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c4170b0234b786853cf263c69f8c14bb031f9cf8dc6febdd19e5ac37d699e8"
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
