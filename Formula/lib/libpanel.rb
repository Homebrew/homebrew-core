class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.8/libpanel-1.8.1.tar.xz"
  sha256 "b87b8fa9b79768cc704243793f0158a040a1e46d37b9889188545a7f7dcaa6fb"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "7a09e359ed1ef3c48218bd445177d2305c76bb265e51ffbed0d82bef3f16eb74"
    sha256 arm64_sonoma:  "a1ad121a497fe726f704c0bb2d7545a39ff4b98fb86a34265b7e41048e236526"
    sha256 arm64_ventura: "728291f360407ba8d12656e8e68b70f6efb1e1194ffb2895450169c5903c7912"
    sha256 sonoma:        "f1abe0c09638d991f4b345eca5bc1f8f10b1d49007419a5b19881c18298b9351"
    sha256 ventura:       "b70a3ef9d1251533a353c1ef8b065d489ab0e7e0bf788e2f65a81ec93d5063a1"
    sha256 x86_64_linux:  "3801d73802a9192ead0368ec17bc5ce7f90381c1e686de59a262889eefbf82fe"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "gi-docgen"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "libadwaita"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libpanel.h>

      int main(int argc, char *argv[]) {
        uint major = panel_get_major_version();
        return 0;
      }
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libpanel-1").strip.split
    flags += shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libpanel-1.pc").read
  end
end
