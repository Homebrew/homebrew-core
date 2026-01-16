class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.58/at-spi2-core-2.58.3.tar.xz"
  sha256 "b0fabea6c9742eda8c9c675f9b8c1d1babba1da82da03ea1103710233717c1b0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "09c80080a21bc80b354103d45a409125c46112aa8e918dd83ce79734013f8323"
    sha256 arm64_sequoia: "3fd792b16f389ff08db307c858f2e9d111f0325fc993d3f1c7a5349c58805d35"
    sha256 arm64_sonoma:  "37346f58a55b1482576449372f9c4d85f04426022a0ae4e34aadf82ed87cc31a"
    sha256 sonoma:        "66f0f44ed5123d59b572c0c67e065702c8af288dcf95e17777b9a31e277769e1"
    sha256 arm64_linux:   "f8d64bc9ebf1a231b026d4a37b08e0ebf850389d13ffc635d0f683f59ba7bcef"
    sha256 x86_64_linux:  "7a979c2a1cea42f1025c3ccf4c089d6ba50c0ab16d84cb7ed5f0fc2658196418"
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
    assert_match "AT-SPI", shell_output("#{testpath}/test 2>&1", 133)
  end
end
