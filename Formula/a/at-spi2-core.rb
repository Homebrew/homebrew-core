class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.58/at-spi2-core-2.58.2.tar.xz"
  sha256 "a2823b962ed16cdd5cb1fc5365029fd218394d852acd4098b321854bd6692f6e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "8b79f2c4fa9bde2418bc4970197b9aa19cca6e7ed1723fddff9972702a4c85c9"
    sha256 arm64_sequoia: "c93fb47b0f426a9f111495e3576c0ce3179b60e6321e4b109311d63a35cd7087"
    sha256 arm64_sonoma:  "6143655ee4251d92af8f4480efc98ccafafe7c62fcffab665d95e1446da06d75"
    sha256 sonoma:        "019329d38025c2ce6f2f2704fbdc49825d6d02bcf233261ab7d46ce69a04be63"
    sha256 arm64_linux:   "6a1ddca14412925c33747714c34d46ed9b6b741f2df823c24bbb3775f3c10233"
    sha256 x86_64_linux:  "7cbd9c2e42caf42100477d2a3101f8780cfe658035f54e0c35e62765ba9cca80"
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
    if OS.linux?
      # Work around brew not adding dependencies of build dependencies to PKG_CONFIG_PATH
      icu4c_dep = Formula["libxml2"].deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "PKG_CONFIG_PATH", icu4c_dep.to_formula.opt_lib/"pkgconfig"
    end

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
