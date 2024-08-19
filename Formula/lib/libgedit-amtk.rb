class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.8.0/libgedit-amtk-5.8.0.tar.bz2"
  sha256 "8acf3c8384846f81fc1e1edd453369b0bb6e05490141a854c09b7365b2402bcf"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "a3b8cde0ae3dce7fe45f0e61ded5d303478eb035929af8991cdc791078bf4025"
    sha256 arm64_ventura:  "1a8ecc89f955d0f51f63a1d4b4cdd4513419cc9d72da6a2bf5e715e69a37f5ab"
    sha256 arm64_monterey: "baf301d49f5cf05665ab91950ceb381b6b94154750355027dc163c9568c1e6fa"
    sha256 sonoma:         "26851791308f3407ee90eee15cb9bf26477cd634778c53ab02f7069068b2e234"
    sha256 ventura:        "29c17f1c43c9428faae1759e25e9e078975f61d947e75adaff0399ee42aef4c7"
    sha256 monterey:       "ee29717adde47f1f32bc8b69230d4d8d43023062168d81da1683e67ad06106be"
    sha256 x86_64_linux:   "61d99af175776561c482cbffa60cdc2438366b67519a9e69e06144deaaae556f"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libgedit-amtk-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
