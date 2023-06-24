class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.net"
  url "https://gedit-technology.net/tarballs/libgedit-gtksourceview/libgedit-gtksourceview-299.0.3.tar.xz"
  sha256 "d80ec2afe87be45eadfff9396814545be15ac32e16f67fd07480e69c100c8659"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "97067f1ab30bc22fd1270b8f8328d5c2898e555833fe043bcd09bcbecb05d64e"
    sha256 arm64_monterey: "a3de0d2879c5ddd8f20e445077b7eb6a9388007ca2a6e6e612de4f9a399c0d0c"
    sha256 arm64_big_sur:  "b4434b583f3627363bf5518148cfe20c08b95436fe635c7d920c932c3d74d905"
    sha256 ventura:        "2422bd8a0a10769298401ca734bab32bdd99bd0865b278b5d2f8f4e3e7e376f5"
    sha256 monterey:       "3654badb45881f71da0b5cd6e3fe43d7b3efb59610c564e406fb876484b34d4e"
    sha256 big_sur:        "113344c915f6cb0b63dce53e64767c610750245be1607262e1269a0529c60469"
    sha256 x86_64_linux:   "110019e307b020a14f1eb4441a0e3565d07ab7c2360102af894c05b452abaca8"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
