class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.62/at-spi2-core-2.62.1.tar.xz"
  sha256 "cca6b6a86e4389d89b370288761ce2385ddeceb10c4412da78689bc30c88af2d"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "3254a0fdb14ef5165f0ae6e162cbc8ba724f669a98d00e41e8c567cf3ff90d15"
    sha256 arm64_tahoe:       "0b3979277d04f432eef86f4f0a77138ff6b494ca9766edcf31c2b5a8bedef793"
    sha256 arm64_sequoia:     "d423cd6758558aeff3e15c36c1b9f5e43c78e6522ca4070486d6003c64e1d783"
    sha256 arm64_linux:       "698896b058d1c581a47ae4b41e6bab956cd21fad118d5686ecb29d0c6285026a"
    sha256 x86_64_linux:      "4c8530c2cb5e4e3f59e57a95c8600a5a0405dbdd87b53a4293240db7fb27e71e"
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

  deny_network_access!

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
