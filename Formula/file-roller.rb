class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.26/file-roller-3.26.1.tar.xz"
  sha256 "ecd5e4c9b8435a6515120c59efeed196ec3f07cb84e1bbda7534cb5456e491ae"

  bottle do
    sha256 "fb2e0cb4f892a5ead43413e8af3a3b5c2ad7f3be1aebd070568499c07723e86f" => :high_sierra
    sha256 "97be4885cf6dd4b815155cf48503daa3877f6f7ddbe14a32d2723dc8f9e6ce2b" => :sierra
    sha256 "4a70941c4394a17fc3ac65fe0c8a330a3fbe2d8eb0f205cfd052026efc9698ef" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

  # Add linked-library dependencies
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pango"

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--disable-packagekit",
                          "--enable-magic"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
