class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.19.0.tar.gz"
  sha256 "eba534fd299f7f3867523b059d414d88aa4e785d8962436f5b944d01638d759f"

  bottle do
    sha256 "a2b2d2bd8eb2d2ca055cbe6a2ff603ed9c2a8b0fa8ea799d8ebfe395bea6b5da" => :high_sierra
    sha256 "6285d0dbf69135901584ce69310307b147851c683ffd2f431782b46e8aa9fd25" => :sierra
    sha256 "12ed12fc32df68c76e457f6dfaf3d74599eabf02578fc903261ea54e7839fc84" => :el_capitan
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
