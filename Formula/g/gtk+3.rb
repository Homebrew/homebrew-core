class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/3.24/gtk-3.24.50.tar.xz"
  sha256 "399118a5699314622165a11b769ea9b6ed68e037b6d46d57cfcf4851dec07529"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+?[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7d63c751171e6dda121f18567dfae8c73e472683004689f926fc1c2f2870cb69"
    sha256 arm64_sequoia: "c8711f5fec80d667cd1eb0bfbcc620a8aee729fe511e57cfba7df74e209b3683"
    sha256 arm64_sonoma:  "926dd56665530a2e37c2ebe4d0313c6facf53d64cae2c961c641a833f7932308"
    sha256 arm64_ventura: "49e3b0b636a54a7349919e892f45be715342d48ae119a7c7c5c2c88a6c46e7a0"
    sha256 sonoma:        "e747c7f437c2d8889186290ace922e4f2bdf29a5b7f9b839a3a79c32e326cffd"
    sha256 ventura:       "31c672e70c2de75a8f156725f2b0c36cfefec5c7639d35f68d7ec0b61895eb88"
    sha256 arm64_linux:   "75cfdb6cba25aeed3ee6462a3bc900ef103515d3cf3546c3d3bdf0d40e9d42d2"
    sha256 x86_64_linux:  "9c268910b9653112e7f8b74b895ddd2939fa1dcaac4ceb110508e100179e616f"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "cmake" => :build

    depends_on "fontconfig"
    depends_on "iso-codes"
    depends_on "libx11"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "wayland"
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
    system bin/"gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtk+-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk+-3.0.pc").strip
  end
end
