class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-2.56.1.tar.xz"
  sha256 "fd177fecd8c95006ff0a355eafd7066fe110a2e17eb5eb5fe17ff70e49a4eace"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "6dc87b78e3eecf5bd86eca6f60e6b0fd110e65a2404549fb62376f4b41063b8d"
    sha256 arm64_sonoma:  "bf9287f8ec0b1f40f4834035bd870dddf1285eb45751825321fb20c73f972a09"
    sha256 arm64_ventura: "8ba19ae5bd9d8fc07bf8425c96a61de2bcc6af015046fd72e7de37e76ab16bb9"
    sha256 sonoma:        "4b561833a27bfffd0585ad22dd1c1326716baf882f24c31abc30fb26790c158b"
    sha256 ventura:       "aaf8b8a3625c0ff5680e733633d5fcdefe8da9022de39ab8bb653c5db08248d2"
    sha256 arm64_linux:   "19b29fc59823759c458ea2a66586c134fc5c113c0f0d2f9a07911ed3aa8c94bc"
    sha256 x86_64_linux:  "cbec6e3ff36f2c59701fec40a0acf2991ee9b5946fe4ae137b3e6923ab734fee"
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
