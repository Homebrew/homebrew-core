class Libpanel < Formula
  desc "Dock/panel library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libpanel"
  url "https://download.gnome.org/sources/libpanel/1.2/libpanel-1.2.0.tar.xz"
  sha256 "d9055bbbab9625f3f5ce6d1fd7132eb6ea34a6ba07a87e9938901fb8b31581e2"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "46cd0d4f81a5c2d5efc63b1755a7a002ff95fa8f42007668a337327dd9970607"
    sha256 arm64_monterey: "9550badfd2988da515c5ff5557014fa3d51a99e4880dd1d20412dc913e57aa2b"
    sha256 arm64_big_sur:  "0bcf580842dc04a29575b36747ff63ec4456e93dca113be677b2efc610f0d65d"
    sha256 ventura:        "d40e0ea4a951ce312ea727f83c1127a0c2790574ddb6e7990d0dd93f5eb6baa1"
    sha256 monterey:       "acfb1a2fe6e8147e6e2e89fadb5890b34d8e6863d040fa39c068c10eb5d21082"
    sha256 big_sur:        "72ee89c1212e23161ab35c91faea62ee9ce2fef2e533b2269b63c8ffd0d3a1f1"
    sha256 x86_64_linux:   "09ffb6416daa2e1367119e976d17d0f7a9c486940eb0b1fe6b42b0b8415fbe0d"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"
  depends_on "libadwaita"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Remove when `jpeg-turbo` is no longer keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"

    (testpath/"test.c").write <<~EOS
      #include <panel.h>

      int main(int argc, char *argv[]) {
        panel_init()
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libpanel-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libpanel-1.pc").read
  end
end
