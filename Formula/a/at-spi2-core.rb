class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.60/at-spi2-core-2.60.6.tar.xz"
  sha256 "a89b64a8b217a8042bdf0e35cbfab629ceee35640dba75df578afde9aa789d57"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "c65850aef234f7d72e37e1cf9cf7daafb736d664fc739cae63bf4ccbfcfcaa41"
    sha256 arm64_sequoia: "9d352a5a9a3438b100dbc3ff5005ec8439b6410d881ab981cc430a16fb0b62aa"
    sha256 arm64_sonoma:  "270753f5a42f888473b8fac04b25417c86aec1d1f8065eff2fe8b514162c6c7c"
    sha256 sonoma:        "599324fcb027bc06256e063f0cb2d3dc6b5d6059bc26d5dfef09f0d35483eccd"
    sha256 arm64_linux:   "35dbe842b9101c0b189e1b8b2edde9efd45da9e0ab99c0d696bad876e23862df"
    sha256 x86_64_linux:  "82fd9a718fcc1d4edbae46ca95234b76bbbcbe26dd76dbe62099bb86127e11ea"
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
