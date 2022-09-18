class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.46/at-spi2-core-2.46.0.tar.xz"
  sha256 "aa0c86c79f7a8d67bae49a5b7a5ab08430c608cffe6e33bf47a72f41ab03c3d0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 x86_64_linux: "f30c087e00d06e8b89ce75d4b0360dee93541a30e07a9e89ff5cab3f36a6f189"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxtst"
  depends_on :linux
  depends_on "xorgproto"

  conflicts_with "atk", because: "both install `atk` toolkit"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
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
