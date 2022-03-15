class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "ee0861dd492a22ca547cfbd8cf89595652ab8e8270f6bad3afdfe0f7da4d9d2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a30f4c77f3b61fc1859f94d1c91e613a7d182adee9e4e78939750ea22e3c0f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f049a300deba9874317cd4aaf4af79f9d99ef7f5c6ad57887d17906fc8d06ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "fbc6a508c2e872ed66032e6b3131cd7b0e51f8ab7b27f8805ee593b6b4ae9a0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "618aec5e61cc14885724e3de983dc5b6642704fff26935027144f48e8ca2366a"
    sha256 cellar: :any_skip_relocation, catalina:       "f33ead944051a340cb8231116faae4723843c381890832e35ddbe5e9ef1bd878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "defb7d2ed1d661711ced096f1fd541ef4c555ef5f9954b5454e60e3781f3d532"
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
