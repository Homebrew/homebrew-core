class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.60/at-spi2-core-2.60.0.tar.xz"
  sha256 "80e50c1a97d8fd660a3fadb02ca35876df881c266d3d6108fc5b4c113614cb99"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "9f10240d7f2e152d0694dc1c499bb0904b5d32ef465f1e2a17dffb580dc03fa0"
    sha256 arm64_sequoia: "8d0f5d633269e1feb5d59530f36f4f9b25b14633d3ca3812cb439f7d4a316b16"
    sha256 arm64_sonoma:  "e823a0efee98929e83750ce1b729a2f5d565b7a58a7878402034457f817db267"
    sha256 sonoma:        "d5c1066543b18a34cdc2e6c85a45a7fbff42feba15feda0da6f88e44e7d67a6b"
    sha256 arm64_linux:   "4d0cbf9c05b9540e382b6cc9ab91d5c8c262e7ec3be829206e5a4a0137b94c96"
    sha256 x86_64_linux:  "d5772836953d6d9a8144461f01f1d1c5f2187c53f0112107f0c6d6d54d8d5041"
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
