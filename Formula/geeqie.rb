class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.3.tar.xz"
  sha256 "4b6f566dd1a8badac68c4353c7dd0f4de17f8627b85a7a70d5eb1ae3b540ec3f"
  revision 3

  bottle do
    sha256 "ee45d42101e3fdcee8f122a87e32e2b8e6e5e0ee93f6e826c4a2e89ce2ade87b" => :high_sierra
    sha256 "7ea4a718e16b30c9d31e20e3e388f6f36147adeedc55163d891ae96219343f68" => :sierra
    sha256 "fa3bf94ddf58ad35ba070e76171cc1f6e75856433e398e9efe083532d6ee7dfd" => :el_capitan
    sha256 "78e9314fd3aeb8a2340b70c8883af54cde29c5c3805c8ead86d44defcfce1774" => :yosemite
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
