class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/44/gedit-44.2.tar.xz"
  sha256 "3bbb1b3775d4c277daf54aaab44b0eb83a4eb1f09f0391800041c9e56893ec11"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "cc000ff6ce9a1a451fa8285e0f4bbf59fc268ad18beccce471aa86d674e2b5c5"
    sha256 arm64_monterey: "b33cb89f188de3fe780f49976fe140265bdf1c376f196302af7d29eb8a1a7fa2"
    sha256 arm64_big_sur:  "cc7b5b656925a805602feda814d96b12bd4f64d00072230e1c03eb55fa607137"
    sha256 ventura:        "a7c193913c461fbb89a0a1f4e78a1cb7b726b38f6bb6d9410c6d61b98b10af80"
    sha256 monterey:       "79f51aa19950f4c483f918ac2759fc69b58494d2f66617cfb737d894cf6a8ff9"
    sha256 big_sur:        "b1957792f7fc3962fb40c0f23b56caf52db23fc9cc6c13de38c643dcc4c8712a"
    sha256 x86_64_linux:   "a758efe0173d7ade8ad0576242917451221904efd1f64b85a1568208fd753e0d"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "amtk"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "tepl"

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
