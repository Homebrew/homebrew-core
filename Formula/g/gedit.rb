class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://download.gnome.org/sources/gedit/47/gedit-47.0.tar.xz"
  sha256 "fa4a597e34c76d4ac91431b5ae6e191c96c6b0af1702e0899ab35199edfa1bfa"
  license "GPL-2.0-or-later"
  revision 1

  # gedit doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/gedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "51674638d4d00e8edcbc9c8b8115928b3e287b19ec892b61a3cc926e01817567"
    sha256 arm64_sonoma:  "1f3f0dc5ce63acb38e3e8bc5592b0c6dc16b2903382f20728f0b259204f3cc7b"
    sha256 arm64_ventura: "b0a5bc3892329acc7c1db2524d08e727f1f9afe29829ef90c3c28dadd9ce0ee1"
    sha256 sonoma:        "c46c1555392987486442205f6e7f9ccf818bf51dd84ad7262e9793ce781056f8"
    sha256 ventura:       "723cb638df5de674615401a6da3f2a7c29e2c457dccc0acb0d7cc4af05281b10"
    sha256 x86_64_linux:  "c247d18996475e1246d5ba269b0b51d85cffb542cb73acd630b5d09199a9e8cb"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "libxml2"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpeas@1"].opt_lib/"pkgconfig"

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
