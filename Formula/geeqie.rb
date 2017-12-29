class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.3.tar.xz"
  sha256 "4b6f566dd1a8badac68c4353c7dd0f4de17f8627b85a7a70d5eb1ae3b540ec3f"
  revision 3

  bottle do
    sha256 "e50d0eda8d81d376738422943730510707ddf4cba4ca6541e1ac3428479b981c" => :high_sierra
    sha256 "f0282fc79dfe15708c2ce91dc4cb1a756005a847277892afa056d23d6accb007" => :sierra
    sha256 "a09af4df9793bcd89d55445dea5e8de6d229cb81cc997cbc82edbe5c2e3e44d2" => :el_capitan
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
  depends_on "adwaita-icon-theme"

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
