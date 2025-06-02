class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-2.56.2.tar.xz"
  sha256 "e1b1c9836a8947852f7440c32e23179234c76bd98cd9cc4001f376405f8b783b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "1d42a8160a64d9e494c2cf98ab3cb7c976df17b88ed8bbf4f77926de4b4492a2"
    sha256 arm64_sonoma:  "b182a1bd6305638f82352d23984b7e540d7b1be23a9afee3e0d6f60eb80b2a24"
    sha256 arm64_ventura: "cc16230760a9d1c2f05467c775ebf2e2c8bf19b88bb55656a839c7125a6699e3"
    sha256 sonoma:        "4ebbfb490a8492db0547a53b5f138b46912c13c6cd7de495a3462451a6392007"
    sha256 ventura:       "fddc5565ddaabc2ee8bf8c432b1100a23faa1260e1c7bc01ecbfc17e5b7ac8b0"
    sha256 arm64_linux:   "aa63615ce117a467355493b1b7f42390314d2af04651949e2834043d1765b5d0"
    sha256 x86_64_linux:  "45cd2ef761364c1331d819db3730efecf3e6734f09fb34a1cf2699685be25445"
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
