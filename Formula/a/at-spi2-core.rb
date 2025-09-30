class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.58/at-spi2-core-2.58.0.tar.xz"
  sha256 "dfdd3300da2783a21969ffade2889817fb7c1906a4ef92497eba65969b3dab5a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "379a4e5a1f967f1856f761949affacf6ed8f13e7b7c14a1537144cbf907a373f"
    sha256 arm64_sequoia: "453b4536f1f3858d9181a94fc49eeb0dc1b08986515330741711674f05a2139b"
    sha256 arm64_sonoma:  "714889751e3585026629752da6713a49a7e8e77dfdf6b42e5c5cb885343aafd6"
    sha256 sonoma:        "82ab50821a7dd46bc4d22f391f2fb9bd1d8458ee34d2e4448e02e35f590a58d8"
    sha256 arm64_linux:   "a4631294361f9f99d5d688995596beb7c9f3df6bb733c421a0a638f1de6fcf56"
    sha256 x86_64_linux:  "5b1898285656a3a211d2b238257b8eea4cf74c8aedb31642f627ee247efb3bae"
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
    # Workaround for https://gitlab.gnome.org/GNOME/at-spi2-core/-/issues/203
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

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
