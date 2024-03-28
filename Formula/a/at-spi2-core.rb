class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.52/at-spi2-core-2.52.0.tar.xz"
  sha256 "0ac3fc8320c8d01fa147c272ba7fa03806389c6b03d3c406d0823e30e35ff5ab"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "ff5e01eeb14e7db7651863f15fe80e74bac6fe884af58aa48fad227b9bb4fe54"
    sha256 arm64_ventura:  "be2bf9926dcb90cb91a2efa12d82a5dd61542f30bf8a44fa78104d74919aa3b8"
    sha256 arm64_monterey: "3864d518fef45312ff7d3ae79c7c98161e4ddf1af86a32e5927638c33cc793d4"
    sha256 sonoma:         "1f344739ceff74c6b3effec6c82da08feab4e404a63c06034172045869bdefab"
    sha256 ventura:        "b3d3cc4309862f55efd46a713f1ba2dd813be0f654f70525291f2a631f1d35f7"
    sha256 monterey:       "5ce9e4f1a004e2d5de65ff205747c0e3734576fb9ae6d5dcb28f69304ad1544e"
    sha256 x86_64_linux:   "3163183968f02b39e5476ac538b74f5e0eb5ac8a613e53da0bd90380cfd2ae30"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "dbus"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxtst"
  depends_on "xorgproto"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs atspi-2").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-lgobject-2.0", "-o", "test"
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", 133)
  end
end
