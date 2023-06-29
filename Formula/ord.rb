class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.7.0.tar.gz"
  sha256 "f6ec720e5c1a34146b0fb32a1ac681f459e71060cdb9bb871ca56652b0eb6c9c"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a71475c60943b6629c37fdef29c41f7ba1d0b0a8dfc7e5285e644ae98d287e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7dbd0c8a2f60ae62d4bc016332a7bad2438fa4165fbf0c9af14ed06e8b55d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846a2645c1f9bea4fa16d5f12a5281628734d462a8486234f7315c536fa098b7"
    sha256 cellar: :any_skip_relocation, ventura:        "291ba7d0644aef56a3786ba5921e620446b97c90cc865d1e38dc1a5ebf669656"
    sha256 cellar: :any_skip_relocation, monterey:       "6ffc680315a26d8bcc800d74b6cab027a4496bb4bf49322c27f3c4dbeda97f17"
    sha256 cellar: :any_skip_relocation, big_sur:        "24f4daa27bdca9c598d4c632631cd3374042debb70040d93f8ed8393bf737a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e04b63f8c64830eae799de9fbe1648043817d5633388a35a052bdba4700124f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
