class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.1.tar.bz2"
  sha256 "100b3d5b1b3370bc2e31c0978991716c4a4478246a2ac2df6382054a0ae89bc8"

  bottle do
    cellar :any
    sha256 "56a9fb56625cb579bac0bd809b934c8147e081dd90fe474669ba650dfc489d8f" => :catalina
    sha256 "7ae283f3e160cf837544567cd015c8c2e7d68499584405bc1509916639f72c21" => :mojave
    sha256 "b7f6fc2e81ca747e6ed8c899bc8353cbba0006959834bf7bd495eb482fd75658" => :high_sierra
    sha256 "0b9773e6206ec4be656de18f2cb8e13e32dc892745867f048f9524d87381efab" => :sierra
  end

  depends_on "boost"
  uses_from_macos "expat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
