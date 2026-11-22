class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.62/at-spi2-core-2.62.2.tar.xz"
  sha256 "7ce81820ddf873b8d930177e0790f730f60d22d8e0acee9ba8f75d8202598de3"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    manifest_sha256 "12549dc12649ac02c726381109132c8ca185a6375ab177d12d0c3941e0eea769"
    sha256 arm64_golden_gate: "2baf25833b4a1aef8f7e82953d9ced5f5d81821687a7b606e71465ab8bf6c0cf"
    sha256 arm64_tahoe:       "6b0c4afc09fb7ee0d3eb915f9c529e16bd3d2761f3bad70680a73ad7aae29d6c"
    sha256 arm64_sequoia:     "74f5f3b01e5c4e1ee0dd30db7d1aebb5d12b361bc8ee55faeedb0a0bc1611efe"
    sha256 arm64_linux:       "dd60c62e9f0e4cdef72e1b962280e4b691c0ae3f121eb37cc1fd7591ddde7c34"
    sha256 x86_64_linux:      "4116a265f5e31e62964bc2eb7e8c89e7d821847e4d9e1857504457728660ea20"
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
