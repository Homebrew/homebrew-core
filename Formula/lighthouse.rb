class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ea9dbfdcfd8c90cfcb8261ed046da41e7f57148840e4947da96dbd55eb60f4b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e76be0c60e372502f6196e737e2b6bb95338177348c81e448c388f198409cb26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da72ca40074a9b9fe1c8f6a27e124c8d4cfc9e8d615c946dc52f776bc500cc66"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3f8a78d2fa3b30686c71e3831c016e390673eb6489ce91ccaae656bed60698"
    sha256 cellar: :any_skip_relocation, big_sur:        "175904ad8f7c5f407c34168afb001a2ab15ca490d71f70416487073c00c35dde"
    sha256 cellar: :any_skip_relocation, catalina:       "a97b97e0526557df5640632f1a17bff99d693d6ea307890f8efbbe49bedb1888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acec2b6e051ee53d9837d47c71b6c0428328e1b35779996fd1b3c1fe5939a372"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "llvm" => :build
  end

  uses_from_macos "zlib"

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
