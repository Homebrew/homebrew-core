class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.13.0.tar.gz"
  sha256 "3eb92f5896b0e5a92fcbee18eb342fbd31688d1d266bbecb9c61819021050402"

  bottle do
    cellar :any_skip_relocation
    sha256 "c160a6bf24d684b98419faa01635ed4134e44d1f0783cc5379700da91611f744" => :sierra
    sha256 "d01aedecd9bd3bc67686111d43215a4459c9d9c6e49cf53197e02da5b90ab4aa" => :el_capitan
    sha256 "c42fbec0fb702b45abf745cca93f2a39cf8c2c3973f55add97e68f4a623d1c87" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build"
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
