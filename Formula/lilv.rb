class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.2.tar.bz2"
  sha256 "f7ec65b1c1f1734ded3a6c051bbaf50f996a0b8b77e814a33a34e42bce50a522"

  bottle do
    cellar :any
    sha256 "a1d348209b1ddb44062fb1503c4abbf7ee6173810e7f3a284cadc2e8925becc3" => :mojave
    sha256 "ea7d9e940e919d52ac64f21364a7498b0c25642ddc2056d83220e14eab4b01a3" => :high_sierra
    sha256 "4ee314969758f0d53d10eae544d858cca171cceacb5119698368ac9c6b8d7765" => :sierra
    sha256 "860fd323f1c16c13857584328ebd97b4603986d405e6f8fe64cfc2394084243d" => :el_capitan
    sha256 "e31927820fa0da477314a4756497cfc2ac6f96d0c279c14e69985725e31f792e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
