class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.3.tar.xz"
  sha256 "4b6f566dd1a8badac68c4353c7dd0f4de17f8627b85a7a70d5eb1ae3b540ec3f"
  revision 1

  bottle do
    sha256 "81d37ee2270c7c7f0b0c38042ee06bdbf3ec1ca4465b75e9687b033a77a8aa94" => :sierra
    sha256 "1eaf69673392f31b14190f6c8430e75a6621e0cad74ad79d3df130da1586e27b" => :el_capitan
    sha256 "b0855a3824ee1d7606c7c7a79b879360536ade7b355b76da57ff3d2a81271d6a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gdk-pixbuf"
  depends_on "pango"
  depends_on "cairo"
  depends_on "libtiff"
  depends_on "jpeg"
  depends_on "atk"
  depends_on "glib"
  depends_on "imagemagick"
  depends_on "exiv2"
  depends_on "little-cms2"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest"
    system "make", "install"
  end

  test do
    system "#{bin}/geeqie", "--version"
  end
end
