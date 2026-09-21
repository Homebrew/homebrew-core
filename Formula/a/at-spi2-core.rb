class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.62/at-spi2-core-2.62.0.1.tar.xz"
  sha256 "fa462f1834bae569c5944c34608872f9447e5a2889ba2aa4d5ff9f2d6ff8a395"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "080256d6e4a921c8e022fada73b1fb9c26a3ac3249cbf51c2c76a1001d90461f"
    sha256 arm64_tahoe:       "8e907458f839fc17a31161fc166aff56ab9f7ac1fffb40bba5bfd28b8af4ada9"
    sha256 arm64_sequoia:     "9d1c368333367703a58b00fa390bdfc7a98623a11a9f862e062e152e3c7a0e04"
    sha256 arm64_linux:       "add1e178850d104d090b6573378bc716d7c3b5b3d2fb1467bfaf73bc1997213b"
    sha256 x86_64_linux:      "8c5b945dac16f6f7ecacce4ef2a891ccfbc8ed5a40c9e429cc9c369e79de9187"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xorgproto" => :build

  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxtst"

  uses_from_macos "libxml2" => :build

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
    expected_exit_status = OS.linux? ? 134 : 133
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", expected_exit_status)
  end
end
