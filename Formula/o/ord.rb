class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.13.1.tar.gz"
  sha256 "9115bb49204b43f966e4d678425371c297171f27fe648bf1a06d9119abd53e4d"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13f10ea2c5628396aef0a0a092bed1fc6c3524ee55daacc8e45c7daa9adc0a1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d17cf50fe880d462b29a3e18b4bd0cb56f764e9eb95cbaccade7b74cdb9efa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "361ed658ccc8e2449b60959cc3ef984433e857e58703ffcab8153b605946688c"
    sha256 cellar: :any_skip_relocation, sonoma:         "be67f80a102c56ba27ff90084a56bbda7e27cd885077a5b2cfb987d7ea0712b2"
    sha256 cellar: :any_skip_relocation, ventura:        "52316e32859337b6d74c770f46bec713356ee39ff30c89d611031a679f69132b"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d17dac01370429793dca968ef374044b016a1b482a2d4de9f8bd877f02bf8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a41a740996cdddcb6c613f1d51beadd1dbf224aafd766f8b6790cce9816a0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
