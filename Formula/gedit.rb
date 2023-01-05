class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/44/gedit-44.1.tar.xz"
  sha256 "0462378d7284ccf8cd4782a4d1ff902c5dc2b81dffcd40285ad543f5945d8fda"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "f58b14d65e5624180d727789c9be7bf9a4ef8fa57fc9f0bb89ce59d1ed31bf93"
    sha256 arm64_monterey: "875897bb86f21a3fad15ac64ce54146d1d6a6924a8e474232693ef3006f8ac6a"
    sha256 arm64_big_sur:  "e6191bb28a2e853fc46a3728ab05f7eaf0d45e58f461b5f7a5128c4ba682d9c4"
    sha256 ventura:        "13383599ba97394dbc5114d69183166778e58c8b96c41790efd089f50ee42864"
    sha256 monterey:       "eb0eb89603a43969303610398364c0cb0b53f4abed1d974ca0d3c43145498208"
    sha256 big_sur:        "7313ac3f28ec871dc349ee34d1bd747cf9006bbf0a576a1bb82c88a97bed8135"
    sha256 x86_64_linux:   "7d107899fdb6bcf2d6c8e892d2a265bc1dbaf4e432c44fa8269320b244959754"
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
