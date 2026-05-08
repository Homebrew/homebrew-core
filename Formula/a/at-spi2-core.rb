class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.60/at-spi2-core-2.60.3.tar.xz"
  sha256 "21056bc04e43e8ed34fdafd916a0ddcc29ec03a4ce6cf5aacac1ddf6ef185ef7"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "b9be04f22a465846f51415d3698cc182d9cde683aeb764799ea3c8a47b71b347"
    sha256 arm64_sequoia: "a28331162db0e7e90ef2547aa6636d89bf8303722697d8c62637975f2a302174"
    sha256 arm64_sonoma:  "32fe759b2132992b62f1dc4255487d7dd6341ac521807ab879f0a9aea6557b0f"
    sha256 sonoma:        "9b7af1c29c8b1d796e0165e16b7005d1ccffdbf6c81df931102e2fd2e5904401"
    sha256 arm64_linux:   "f68c7930a954c03e3aee73e1b9507409763baf109e360f36b1ca047d9c45f511"
    sha256 x86_64_linux:  "47ac126cb94a6ce42684374c2cf85bcce70c6bbd0841c4954b4803ad808da79e"
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
