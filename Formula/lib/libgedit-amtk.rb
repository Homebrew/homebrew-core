class LibgeditAmtk < Formula
  desc "Actions, Menus and Toolbars Kit for GTK applications"
  homepage "https://gedit-technology.net"
  url "https://gitlab.gnome.org/World/gedit/libgedit-amtk/-/archive/5.9.2/libgedit-amtk-5.9.2.tar.bz2"
  sha256 "6a3bf9c5ec35e7d2009dfa759567b1682fc12ebf98e9ab140bb14847d71f13f8"
  license "LGPL-3.0-or-later"
  head "https://gitlab.gnome.org/World/gedit/libgedit-amtk.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "4d014e2db6cf450d3c95535fe6cd5e23e13867e8c3fc8d3654cc316dc365cca0"
    sha256 arm64_sequoia: "5e8381bb9eaee60ce832afe5ebb36f59d06ba09bd9886c9390315978d2ec5c54"
    sha256 arm64_sonoma:  "d20d36510f9ea433a88645f47b52e1f7c712dfed1df82e10fe36892d767e0724"
    sha256 sonoma:        "ba784b6440e0790e8ca925ac6dd2b495fcbdb834b6ce7c897b0a45c436b87308"
    sha256 arm64_linux:   "dcbd37d870e5eca41e066a432a049e6b4fd2233e21aa58bae8aad5d16bca950a"
    sha256 x86_64_linux:  "b4d7422e0e1950783ce2fa54756c8e9b997ffb3f3493395f1a7c5857c98cc80a"
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
