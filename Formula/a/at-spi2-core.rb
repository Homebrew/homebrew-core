class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2/"
  url "https://download.gnome.org/sources/at-spi2-core/2.58/at-spi2-core-2.58.1.tar.xz"
  sha256 "7f374a6a38cd70ff4b32c9d3a0310bfa804d946fed4c9e69a7d49facdcb95e9c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "b23a823a46d17607d897d586d6ad7597970a2cf43eb8f97df62f1cc181cf4471"
    sha256 arm64_sequoia: "4dff654ebf86dda945fd44f209092ebd57e456f2ef647347506a06a1a02e08f4"
    sha256 arm64_sonoma:  "1863b61000d7d817761a3b5b734412d27ff39d2c0fd40b6ab484ce12514cf0ad"
    sha256 sonoma:        "0b1c0981e638df2e28b0a581c4df8380d6c28024036d26876e18bec26ea69fcc"
    sha256 arm64_linux:   "59a1a31b41bfbc99abfa581259d02dc04b8e0ba51037d9ceb95124bb61f92b83"
    sha256 x86_64_linux:  "a13915bb502ab4f838dce3c490e2f87a640eb92b4b7187d7791db3775762034e"
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
