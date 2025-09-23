class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.56/at-spi2-core-2.56.4.tar.xz"
  sha256 "dbe35b951499e1d6f1fb552c2e0a09cea7cba2adf6c2eba0b2c85b6c094a3a02"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "b655a631d05ee3e4d6d5db104446bec6593d3f240d4dcad9dfc4010c1fbe69ae"
    sha256 arm64_sequoia: "eb6790869d525f4e60efa86d0f8d4393bcfa731b0ea428aed854d2bc369b2d19"
    sha256 arm64_sonoma:  "d3a71ffcdd7e6f41166381e05d6b659df11061150a60246b3e5d08339dcdcc8d"
    sha256 arm64_ventura: "ade98c260a0781f8243689f9f86ad8ad09acf446919d656ff44ca07a84cbdbf8"
    sha256 sonoma:        "a0c090f3bb57c2237f012ff347abcda89f0c2481b5a06acaba0806ce5ec518fe"
    sha256 ventura:       "28d025e00a35ffb860474d237df2b679fa33b11c5f1165c3a0c0ff6e147e8bba"
    sha256 arm64_linux:   "3c335185fc9e3650051422b718ef49cb33ec8362e7dda83597b2a4b2fd8ea8dd"
    sha256 x86_64_linux:  "4707a71272f8f60d3a22ced6e86eec2c0843846fc79f2ad363b13a56e48c492b"
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
