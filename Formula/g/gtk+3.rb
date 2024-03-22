class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.41.tar.xz"
  sha256 "47da61487af3087a94bc49296fd025ca0bc02f96ef06c556e7c8988bd651b6fa"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0ecf522f1a849a3fe6aa5dee9eac59299dbff915867072bb97e15b549d845119"
    sha256 arm64_ventura:  "e159fc2e0b152ddddc93b993135ae244f248b460a40be262a7850411619bc43b"
    sha256 arm64_monterey: "cd280376f5aaffd7dbbff981945545505ea5d43c2f89a93f4e281ed0d637817e"
    sha256 sonoma:         "48366e652852b57e0c30e3af7697a65113aec9a7247232e1ddacd308ba548b4b"
    sha256 ventura:        "493eb5a730ff13f34da70af0aee792ea2712b00d06fb82793dd0632ab18c3e7f"
    sha256 monterey:       "0c32e4dfe268d0917f5f85d3f08ec940f886507184a2a24746d4988aa1b0a6d9"
    sha256 x86_64_linux:   "d7e9fb8c42e711fdc21337785008dda4e06fa77c7ca8f28dc4674f9156cf0cb2"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "at-spi2-core"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "cmake" => :build
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
