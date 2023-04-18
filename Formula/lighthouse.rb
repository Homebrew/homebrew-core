class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "ada195504c1c0e441c52def44e7f0ba6eb8fd69a1662ee39c6092a1db6627317"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e08d64897042421219492ebce8461c4698ce619ff52714dff314eeb8c1d119"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79edc35709a394f10adcd3783ef9c3ec6e78ece2c8d5410495dce8131a495fa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5815b153b1b3650e1d2ecd6a10383b5fa15192173064583da6f23b16fceaf901"
    sha256 cellar: :any_skip_relocation, ventura:        "8d320b58a3bf0c7e92b6168744dac3ffaee950eedebe29ff93e0424d9492a73f"
    sha256 cellar: :any_skip_relocation, monterey:       "cef9618a3ea6d68c3f1f0458338adcf7c9b068fdfb2357ef318b45394b8ba9f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8f52ca58d573c0755e3e90bc4754954043d7f83e01ff25db4a729bd1397a669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "785bc34fa35180dbf1122c7df9a760d3365aa8ee3a06765566e5596bae101ba7"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "zlib"

  def install
    ENV["PROTOC_NO_VENDOR"] = "1"
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "./lighthouse")
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
