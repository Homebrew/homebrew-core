class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.10/libpanel-1.10.4.tar.xz"
  sha256 "593888a7691f0af8aaa6e193c9e14afa86a810c0c2f27515c6d813f18733b1cd"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "6a216b47f6d3b8df07769ae54d79e77fe2f2b0e7eb16047ff8db33a84f0cea27"
    sha256 arm64_sequoia: "95582ebb4c8e063b70512ab54d77412704e028012961a854fcb18cbe982433be"
    sha256 arm64_sonoma:  "3b6e6656f461f9eba108dd2eb5478a611b75c15007c97469a446507ed63a4db4"
    sha256 sonoma:        "ae99017a0cd281b87384b01b450f8d8249906edb252fde63a95c33a3dd7d70f9"
    sha256 arm64_linux:   "ba6e37513eedd02b62735e484d834426953a80542b35c59cb73aaa8a2c3c9e6a"
    sha256 x86_64_linux:  "53941d0e1aa07814775b7ec7602c02bf1365af0446542537e7f14a1d3b1b354d"
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
