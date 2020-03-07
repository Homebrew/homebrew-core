class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "http://www.geeqie.org/"
  url "http://www.geeqie.org/geeqie-1.5.1.tar.xz"
  sha256 "4854d5d323c31f8f4068fd73ab2c454ff91e826c4ca4d37b22c246ad14dea10a"

  bottle do
    sha256 "ef2ebcd4940ea2d0a9985aa5addc8dfd33b05e43d225dbe945fb887813ee00dd" => :catalina
    sha256 "75b33a9960e789726d0f18872afe1a75a63bf4c0d25d250a22b0ffd5f0d3de34" => :mojave
    sha256 "028bf0b7c84969f4e5d2172deb13407904cfa878fce673767268625b825501f6" => :high_sierra
    sha256 "c5dfe4a3af57167f2058175beb434db98acc796e21c7c3775e52f88a87d13228" => :sierra
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
