class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.18/gtk-4.18.4.tar.xz"
  sha256 "d4783ac15037c2c4275a8f1acc94f5fede28a516243fccb92ff54a11c15775ff"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e4dc445dc7bb413ae406ba5cabf02ea23b111dd565ec406411e8be8207c5bb48"
    sha256 arm64_sonoma:  "1b7af15f382764cb7d457d72cdc0ee137039b1491587806ec976c3c139aa62b3"
    sha256 arm64_ventura: "8d895753b5dbd8c660b644896010d68360b1f2861b78cd1f8b8b8a6575cf7913"
    sha256 sonoma:        "72dfe657e87d8525b240b162cad99a9a9699d4bf4ebb0b10fe93cc294319515c"
    sha256 ventura:       "28361e76c1e20ee65eef9630f98b52719c95ed3daf7d52a42d6f6b1c0a483bcf"
    sha256 arm64_linux:   "3bce6dace92d66a924c24c921fe210ca05e71610cb327d734c95d03dca5723c3"
    sha256 x86_64_linux:  "1d5004ea4ec1d2b593e49525699188c5ef72b64a4e48075776f6cd17054b9ec2"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg-turbo"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "wayland"
  end

  def install
    args = %w[
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dintrospection=enabled
      -Dman-pages=true
      -Dmedia-gstreamer=disabled
      -Dvulkan=disabled
    ]

    if OS.mac?
      args << "-Dx11-backend=false"
      args << "-Dmacos-backend=true"
      args << "-Dprint-cups=disabled" if MacOS.version <= :mojave
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable asserts and cast checks explicitly
    ENV.append "CPPFLAGS", "-DG_DISABLE_ASSERT -DG_DISABLE_CAST_CHECKS"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules", "#{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/printbackends"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    C

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end
