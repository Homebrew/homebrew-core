class Lighthouse < Formula
  desc "Rust Ethereum 2.0 Client"
  homepage "https://github.com/sigp/lighthouse"
  url "https://github.com/sigp/lighthouse/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "53db198ceba81229ec2a7b44e48e20cb211c178d5026c4856636ef97ce5b5834"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c21981773c09e5340ccbf438be7e0c5264d2f656b846982223055f8d995c80f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a13eb89f5c6c6a3a95bd1740fdba4071ed5ec18f2216f7bd569d37d6022d1fcb"
    sha256 cellar: :any_skip_relocation, monterey:       "f27a14ccd8b03728a851c58b546374663f9ecf88d5bb95cd1820c065c2254e8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aca60e9c2af0bd49859e49690f536f6fb8fd036d5723538ccb754ca05787ef41"
    sha256 cellar: :any_skip_relocation, catalina:       "83ab10c2d46953348d967d22a172be5d872520aefb2d821db6b9f7675b9d8bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "987d7116d6c8e4a58e244abad9640df3372e4e2d85e79a2de471cd5255631866"
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
