class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.10/libpanel-1.10.2.tar.xz"
  sha256 "cc12e8e10f1e4977bd12ad3ffaedcd52ac176348b4af6fe5da686b96325bfe01"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "fecceb250bf6531b94c8c592d2ad2d83a5424546eea72d8f31df346852002f0f"
    sha256 arm64_sequoia: "2518268a98407e1225dfe3ee8714f5c61d3accd01c510529ad8c3c7e4c958091"
    sha256 arm64_sonoma:  "43b94427b0b52907d86e881d2fe4f1ac6f091fdb2494c5afd4393432e25bebd0"
    sha256 sonoma:        "e31cbff58e1137cf1a3baf77667f7f714fb48b5d2d6484c17ad9484a448e5fd1"
    sha256 arm64_linux:   "953102c6e8e419ed88e5b7e28c3f6edb1015eb2162a6476b6e7fdad910cc854f"
    sha256 x86_64_linux:  "58efad9d44a5179096fbde3c3f493ea455550b060a12d250a6d671d32f292621"
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
