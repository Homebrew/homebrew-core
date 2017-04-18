class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.13.tar.gz"
  sha256 "7b2e69b0e400ffd727fd818d926484c3f15a51cd6b325cea2483354501d6fce9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b520aadc300e1660d66e8ee26712405b3581ad32b20c119908c5890d90f721e9" => :sierra
    sha256 "55630d52364af42172ae1abc10847110fabe93f94ae21708863803be7c35fdc9" => :el_capitan
    sha256 "37d26466a7deb14cb2f38cc7eff1621eef652239bb973b3f5c5c870cb624399d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
