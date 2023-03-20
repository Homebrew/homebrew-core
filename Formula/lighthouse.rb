class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "5e5c7a5f9ac4dd7d079f43a0e872ba80ed647457a4008be2a61e061cc0226aee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10968d29f2797b9bc1c527735e689a2e68f0d0e3cfb4f7384d0d4273ad63963f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e863d0997ff9765a967e7e3f5927fc97e34495fa30e5b47b30abe531cd18a575"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9bf914ed4a92ec5b14085c5440c0fe2056ad63550b922fcf0059aa4bf84046"
    sha256 cellar: :any_skip_relocation, ventura:        "5f4c546247f6d54bd44441b25004e27b0742cc787babcc9ce32ac0e18935136c"
    sha256 cellar: :any_skip_relocation, monterey:       "827ef59765895c1c6a3e0502bcb7bc0474c22ae40515f55020d3998a92f5a690"
    sha256 cellar: :any_skip_relocation, big_sur:        "256ba111c641c669d1905cc23821ce0263b420e7981e8fc1b3f65f03981513cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714a82f4ff2625998868974f9069ceb55f0933dfacdb2e3ddfe0f2dbee675205"
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
