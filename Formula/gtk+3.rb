class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.36.tar.xz"
  sha256 "27a6ef157743350c807ffea59baa1d70226dbede82a5e953ffd58ea6059fe691"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "9f50dc6891e966c5c64cdc1830e9e7bf3ff066dc25b783fd4abd10cfcaa31bfd"
    sha256 arm64_monterey: "c0a3f9c2f4019739da142711867e7cbde728e8a53746d74c1203a20fcc911691"
    sha256 arm64_big_sur:  "df1cc6b2751b342bae206d400020795ec99d6231ba37c9125a94be2fdb4185f7"
    sha256 ventura:        "be0e0e5c46ded73926df9a00df059b334ab5d620fdebda55578168ba9ff62288"
    sha256 monterey:       "a88bd8612540f4c608152a244079887d8c404754a3897311608a6bb10a72981c"
    sha256 big_sur:        "be1c7bbe919519333e1b6ddc7eb2b88304077a88ec9f4ba2cec03cfe7f5d0803"
    sha256 x86_64_linux:   "4f346fe9908956f892353d644d3a8c7ab236c66ea3aac0ea354f7fba7168dd9a"
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

    # fix ERROR: Non-existent build file 'gdk/wayland/cursor/meson.build'
    # upstream commit reference, https://gitlab.gnome.org/GNOME/gtk/-/commit/66a19980
    # remove in next release
    patch :DATA
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

__END__
diff --git a/gdk/wayland/cursor/meson.build b/gdk/wayland/cursor/meson.build
new file mode 100644
index 0000000000000000000000000000000000000000..02d5f2bed8d926ee26bcf4c4081d18fc9d53fd5b
--- /dev/null
+++ b/gdk/wayland/cursor/meson.build
@@ -0,0 +1,12 @@
+wayland_cursor_sources = files([
+  'wayland-cursor.c',
+  'xcursor.c',
+  'os-compatibility.c'
+])
+
+libwayland_cursor = static_library('wayland+cursor',
+  sources: wayland_cursor_sources,
+  include_directories: [ confinc, ],
+  dependencies: [ glib_dep, wlclientdep, ],
+  c_args: common_cflags,
+)
