class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-2.56.3.tar.xz"
  sha256 "0e41e1fc6a1961b38b4f9c0bea64bad30efff75949b7cdb988d2f2fdab72267a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "e6ce3d11b86f1f11c7193f3335f3697676759abad4b01d8824a6162cbd006c2e"
    sha256 arm64_sonoma:  "b4e86dbc5d2b1243309fc25794758d8f0d40b50789e364367920833a65090121"
    sha256 arm64_ventura: "c510ba1771adda6e3a88be7a3784e7bd695ca606bd80a19dc55ab9848f33f5fd"
    sha256 sonoma:        "7411120d55974056aee8f75317cc2fc215fda4bbe0be9899f60a1059c2f17fa1"
    sha256 ventura:       "5f3012bcca8189bb7ca69a68ed49cd1eef7b4de8de75d4467750324ef99192f1"
    sha256 arm64_linux:   "bae92fd43f2717d258787355128f6c4b26dc95a6528bd43b51499e8f884cdaf0"
    sha256 x86_64_linux:  "d5121ca9b226f8d5ffd499acb5c04bd0d4650d3e2b87f7621546ebff2dc27a8a"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxtst"
  depends_on "xorgproto"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      /*
       * List the applications registered on at-spi.
       */

      #include <atspi/atspi.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <string.h>


      int main(int argc, gchar **argv)
      {
        gint i;
        AtspiAccessible *desktop = NULL;
        AtspiAccessible *app = NULL;

        atspi_init ();

        desktop = atspi_get_desktop (0);
        for (i = 0; i < atspi_accessible_get_child_count (desktop, NULL); i++) {
          app = atspi_accessible_get_child_at_index (desktop, i, NULL);

          g_print ("(Index, application, application_child_count)=(%d,%s,%d)\\n",
                   i, atspi_accessible_get_name (app, NULL), atspi_accessible_get_child_count (app, NULL));
          g_object_unref (app);
        }

        return 1;
      }
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs atspi-2").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-lgobject-2.0", "-o", "test"
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", 133)
  end
end
