class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.10/libpanel-1.10.0.tar.xz"
  sha256 "578ce512278ff2bb5eeebb55099392c52537a5abd9bd0629567f102532b38b25"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "0a5552ed52318052bc14e11ba4168637fe2f3c2c46821c1810d564fffe9fdaad"
    sha256 arm64_sonoma:  "2681e0027b3411e923595e24691c4b1d867a4beae343cd51d6c16170804ca923"
    sha256 arm64_ventura: "33e2e6277da744ef4bcf8a5e6f8c67c420e0ea01fd7a0595d1146aaa679a04ed"
    sha256 sonoma:        "1f26b084e8718cbcf8f291f424708286240481f51523f8564e31585f4f9c6873"
    sha256 ventura:       "572f34729874164856a75bcb154781667ca9752211df336f291d14558fc03e9a"
    sha256 arm64_linux:   "710b8e8bb9afb70d5ceb2c114858dcf89afd10ba3b2879ff2b052067acf4282c"
    sha256 x86_64_linux:  "11bc6daef14e7687c919e34b2a38da7d98ea0cbf7ea25c1fcd611c6af6066e4c"
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
