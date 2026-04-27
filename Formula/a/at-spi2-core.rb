class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.60/at-spi2-core-2.60.2.tar.xz"
  sha256 "901f8acac5f5c28b9ff2aed98de5851f4c7af6123dda73d30c4d925796e88861"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "9e63e358d8bc73913fa967e880fafbcf099ef03755840faea3f5d193e4471cd7"
    sha256 arm64_sequoia: "51cc0c47364faeff9305b3b720b5e9a88e6ac7fe066c81e96cd59cce11c7c8e1"
    sha256 arm64_sonoma:  "ab9885ed004f9dbdeb1c6c8b4d3515e512a34d7b4827e1109d59cf6d372e2e2d"
    sha256 sonoma:        "23a0245fa6c06ce1c842d0de8ef80ead1558b220fe71f64197ac28b78f9ab5e3"
    sha256 arm64_linux:   "a3f50ff4ff6328dfa324f086385c52444b54a8cc4fa159234f68f73627d97ec5"
    sha256 x86_64_linux:  "67b5e277f372005da07dbf805a6602799166d82e3e3e697843b520b9b1a43045"
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
