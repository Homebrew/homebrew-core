class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.60/at-spi2-core-2.60.1.tar.xz"
  sha256 "f99b87e3c1674f5fbc417cc9c1d9e261c0f29aab0550ad6369805031d12f6852"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "f3d06580f2c41d12893154b26713c0851698d70665d104457b4ce335ba5f9aac"
    sha256 arm64_sequoia: "0620968405904e7734a05d89b72c2f2118a6f7ea9b9fd6abb17010ec95e88de4"
    sha256 arm64_sonoma:  "14c138aaa39bd1211c3c6b5a2f7d6a1a7acc73c0d7c0a525d4d24d2c12b969e7"
    sha256 sonoma:        "2ebfb5a3fdc02fca61dfb4288e7015f3294517a00df6d1613a00500edc587b0c"
    sha256 arm64_linux:   "cb43149b82f64dc9956d0ac8be386a340d6337ca2c69a5447f05bfad0cc8f219"
    sha256 x86_64_linux:  "ba3f9ff502b8e493f5361197d88fcf7eecd0e2d5f5b2ddaf59cc0a76f7007c3b"
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
