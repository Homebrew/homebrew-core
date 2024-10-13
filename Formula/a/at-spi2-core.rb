class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.54/at-spi2-core-2.54.0.tar.xz"
  sha256 "d7eee7e75beddcc272cedc2b60535600f3aae6e481589ebc667afc437c0a6079"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "e593b674b0e959eef42b4072451cf34a56082a4a00d58a27a187f5cb893118c0"
    sha256 arm64_sonoma:  "13ddf331202d2f26478c0d2874b7c29d02fa7adda274e33bdb49d8b5115e3a43"
    sha256 arm64_ventura: "8aa34bba472670a471e0d105875a8cdc08ef53d852224caa0588dfbf805a7b5a"
    sha256 sonoma:        "36aa898dd88a1334f346684f4a09a6535774c43ee568b8f035a24c38cf226378"
    sha256 ventura:       "8591d35b85eee65936789b8bcfd15734fb5d7da01652219704db8456788fd52d"
    sha256 x86_64_linux:  "202197a5e6cd0df0a4b43a3feb3f55f3ed8eef4443e635525a74df46c2d372ac"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

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
