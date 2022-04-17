class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "1a7478361fb5116fdbf1b65eb209469448cf363279b718c0e5d7e5400b4abcad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e137a78561da772c7eff1eb3853e66a08f3ae940191df3761620bcdf5b33cfa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06d7b223b60d8d19967e567b32ac754b80c52e703e7f65b4a1b4b29b730825f1"
    sha256 cellar: :any_skip_relocation, monterey:       "fdddf267454f16e4d784810f972207de0b4472bb761354e2893f32339b2f525e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5db1581205a419fc949f93fdcb79eed3958c0b65f34dcc75ac3b631425b63c63"
    sha256 cellar: :any_skip_relocation, catalina:       "a6f6239b8141a1ba5e1c1da47018fc464b0098bb0983d5e3d90c77b89bc93c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fbef224549682135cbf684655a7f1406651b30d4cf1d3fdc265d9d5beeedbf1"
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
