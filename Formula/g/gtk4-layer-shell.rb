class Gtk4LayerShell < Formula
  desc "GTK4 library to create desktop components using the Layer Shell Wayland protocol"
  homepage "https://github.com/wmww/gtk4-layer-shell"
  url "https://github.com/wmww/gtk4-layer-shell/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "1ebb01ab14e98afd1727f68f64981c37bd23305b1f131f5667c02b94cf593192"
  license "MIT"
  head "https://github.com/wmww/gtk4-layer-shell.git", branch: "main"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "wayland-protocols" => :build

  depends_on "glib"
  depends_on "gtk4"
  depends_on :linux
  depends_on "wayland"

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk4-layer-shell.h>
      #include <stdio.h>

      int main(void) {
        printf("%u.%u.%u", gtk_layer_get_major_version(),
                           gtk_layer_get_minor_version(),
                           gtk_layer_get_micro_version());
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtk4-layer-shell-0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags

    library_version = shell_output("./test")
    assert_equal version.to_s, library_version if stable?
    assert_equal shell_output("pkgconf --modversion gtk4-layer-shell-0").chomp, library_version
  end
end
