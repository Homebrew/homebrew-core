class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.11.0/libgedit-amtk-5.11.0.tar.bz2"
  sha256 "eda52600fc2e8b49f98fe974397a75e0286d744e09446b13e631202e99ca536e"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256               arm64_golden_gate: "a4edf7a352f21a83c16f35101256fe211d54cd6e8dd37e61a5adb2cc555b1180"
    sha256               arm64_tahoe:       "bf6e1c6179c0190380459078383dd608aafc6eee94823780932788b37e2ad950"
    sha256               arm64_sequoia:     "ec6710d7195e655119de78a483ebc360081cae31cd20d5bea265690abe2b147d"
    sha256 cellar: :any, arm64_linux:       "05f37155ad5ee5c57387d3f8b2cdd77bc4b674f935bd327beba390719f5cda48"
    sha256 cellar: :any, x86_64_linux:      "f7e2dbeb17000801dd9ff0834d49da19cd49201ca8ed7907412fbb0211b8547c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

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
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <amtk/amtk.h>

      int main(int argc, char *argv[]) {
        amtk_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-amtk-5").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
