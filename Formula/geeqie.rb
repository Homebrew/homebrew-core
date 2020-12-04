class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.6.tar.xz"
  sha256 "48f8a4474454d182353100e43878754b76227f3b8f30cfc258afc9d90a4e1920"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?geeqie[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "a501e8d8c8c16f456fd3febeee883b37b329286b828f1799070691d99a52d66d" => :big_sur
    sha256 "5d344202876e8d095f69c10241a7018a97d4033f1e6c5fabc8db0f8152dc4d1c" => :catalina
    sha256 "80074bcd449427974fafe01f1292d3d77111bb380eac0b94f91797a4802a2108" => :mojave
    sha256 "bb5923d1d1a922ea077796653061d98b571bb96a89bb16d555ed5bf91770e79c" => :high_sierra
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
  depends_on "libx11"
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
