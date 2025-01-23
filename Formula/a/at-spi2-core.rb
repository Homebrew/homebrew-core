class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.54/at-spi2-core-2.54.1.tar.xz"
  sha256 "f0729e5c8765feb1969bb6c1fba18afa2582126b0359aa75a173fda1acf93c4c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "4264bd769015c0ccdbb58594426089453dc8a2d87e96903bd5e472a6f4ad657a"
    sha256 arm64_sonoma:  "242f10012d6f91d57a00cc89f493c36ac8397855c6e1054dfa53fb1de56b1d41"
    sha256 arm64_ventura: "37647494241aaf057e9be263d3ebcbb1424d2f1bc3697623202ff5d903036adb"
    sha256 sonoma:        "4429f84c5a3a1824cbd55a0c662123bc7d03bda08efa898a754912875a745067"
    sha256 ventura:       "e435be0dddb4487ccd8107f6deb4eeed662e58a8f9c856a8e5ae4c8028e89a86"
    sha256 x86_64_linux:  "6306633df318eab967fcba50c9814926df2462d67b0b3c1f5583c4233ac5dbc2"
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
