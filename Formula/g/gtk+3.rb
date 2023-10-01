class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.38.tar.xz"
  sha256 "ce11decf018b25bdd8505544a4f87242854ec88be054d9ade5f3a20444dd8ee7"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b079594552eccc9b13b01d55022811bf9acc981e62d0c107ad9d393a05dc4ef6"
    sha256 arm64_ventura:  "12d42f5ba7caa43a83aba5babfee4cc745d8a12a58e108af642f366f2ca37d8f"
    sha256 arm64_monterey: "9c57deb4a8e1360dfd057a58a24e6c7b4ce621ebd5916386cb8c4cd359691763"
    sha256 arm64_big_sur:  "ce48bef582169d1f45bfa828b80214c9dd5204573699d2d97e631d29bdfcda27"
    sha256 sonoma:         "9f283bf5b2b118d771aa7ef628b8798e527a7d499f225587295866c8a2dc39cb"
    sha256 ventura:        "87f200d7945307fcb47cb2ea31da643d571c898b752e2e2ddecd62c1c4c64b51"
    sha256 monterey:       "e0a18e7ae38a7ea9d5705e787fa01f3d4215c836e170f060662b85c1c0dd50cf"
    sha256 big_sur:        "ad9c04a5ce0db0751cf1a485d60ec963aae7039c9332e0bcc972e06daacc8cc5"
    sha256 x86_64_linux:   "84b8d60884ca0e11d3d86785415dd9d1d426c4900e9f3b62c71e0dc0ad0b2745"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "cmake" => :build
    depends_on "at-spi2-atk"
    depends_on "cairo"
    depends_on "iso-codes"
    depends_on "libxkbcommon"
    depends_on "wayland-protocols"
    depends_on "xorgproto"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    if OS.mac?
      args << "-Dquartz_backend=true"
      args << "-Dx11_backend=false"
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.install_symlink bin/"gtk-update-icon-cache" => "gtk3-update-icon-cache"
    man1.install_symlink man1/"gtk-update-icon-cache.1" => "gtk3-update-icon-cache.1"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{bin}/gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gtk+-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk+-3.0.pc").strip
  end
end
