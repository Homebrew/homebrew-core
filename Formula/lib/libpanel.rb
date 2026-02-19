class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.10/libpanel-1.10.3.tar.xz"
  sha256 "42a01baf8b94440f194ea8342b244bd6992dfb024ca3160c9477ff498ec3a2b6"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "12eaa8937622e98506989318e75eef0027c5b40969b71848526fab79e8bed9ab"
    sha256 arm64_sequoia: "9c799c1607005d0c27b0d5b36e9950088c0f451b80337acb8617028188f5d119"
    sha256 arm64_sonoma:  "b9f08a1464399b7ceab6ef0b97395e7b703308f8333b6dedb8470a3aeca6f440"
    sha256 sonoma:        "dc18fab62e41c2970520660199eedc17478dbf9fdf4464cc3ccd8b37b13e9f34"
    sha256 arm64_linux:   "d3cfc70aca6f786d93cafcbd41e444e81215985181709e5641e9344e324d2dab"
    sha256 x86_64_linux:  "69c8e6a661a5ea25c5c80b2f2a9284cca627605e68699276782a7585edfc9fb8"
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
