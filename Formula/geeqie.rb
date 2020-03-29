class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.5.1.tar.xz"
  sha256 "4854d5d323c31f8f4068fd73ab2c454ff91e826c4ca4d37b22c246ad14dea10a"

  bottle do
    sha256 "a7bbe36c785e34b9c8b03aad0f654104cb771fff926e231f0996541ec4fec6af" => :catalina
    sha256 "888a5a8a95a9c560203470469732c6a78933ef6936c0e30be9217fb48a61c024" => :mojave
    sha256 "34bd849466a1f2c6984553a070e9b42446562c1b3e49867cd12457f8c2ce4db4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "exiv2"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "pango"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh" # Seems to struggle to find GTK headers without this
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest",
                          "--enable-gtk3"
    system "make", "install"
  end

  test do
    system "#{bin}/geeqie", "--version"
  end
end
