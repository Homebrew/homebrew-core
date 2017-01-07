class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.13.0.tar.gz"
  sha256 "3eb92f5896b0e5a92fcbee18eb342fbd31688d1d266bbecb9c61819021050402"

  bottle do
    cellar :any_skip_relocation
    sha256 "45e5f89b14ca4808cda71d700552b30ce5d49f41ce3b2750e30af33de75c2709" => :sierra
    sha256 "bf343de2cf3d8861c3cee06643e1598a6092450972ad82b006e77aef3ef864eb" => :el_capitan
    sha256 "d89ff07e964f2f0b5dafb3a5f80ea04dd639071fa4578ec8ab84f922e250b5ef" => :yosemite
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
