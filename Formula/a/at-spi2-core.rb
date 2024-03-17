class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.52/at-spi2-core-2.52.0.tar.xz"
  sha256 "0ac3fc8320c8d01fa147c272ba7fa03806389c6b03d3c406d0823e30e35ff5ab"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "80aaf2533ce03dc233d730cc3bd1bdab830e27d38f87291f161e79c2f1eb4242"
    sha256 arm64_ventura:  "4a1674b6d6e0cc8b0ad553c0ea923f4b878ae9125ee1ff0fcca8ab7a1d50c3b9"
    sha256 arm64_monterey: "b2f67dd05f075d90b9181c75d00a571ca0251e328fb42596ce4b7de341c11f27"
    sha256 sonoma:         "3bf961a90d96a7a0730f2ad2fddc45dba349bb1895fc6e1cbbc740acb4000aaa"
    sha256 ventura:        "b1b1f7001d3b3aa385433c90a9ab3d321f26672408343d346bb2c744e5500741"
    sha256 monterey:       "dfc6ede27c5ad8563c0ccf12ffbccbd0dffd811e748900e390d1df31c9b6cc03"
    sha256 x86_64_linux:   "2563a9624511ae314883ca1bcb58313a92dafe369e0441c9c1a147d0f31ca9f1"
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
