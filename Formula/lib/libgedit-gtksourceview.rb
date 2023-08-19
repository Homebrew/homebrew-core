class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.net"
  url "https://gedit-technology.net/tarballs/libgedit-gtksourceview/libgedit-gtksourceview-299.0.4.tar.xz"
  sha256 "7453a1cce2f6d58871644d2203ecdbbb043050886170ebea376c1cf6e27f86d8"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "e1b228a6b43a9a3f1cd43a2017014adc8d74b1d85973a490f1ddfa19c14497f8"
    sha256 arm64_monterey: "83f00a72e7e9d585ac1395b0b12eaf81d9af7ececa2dfc06b900e09a8f8f61e4"
    sha256 arm64_big_sur:  "b12dd1b65c18caba24db09b95fe0deba3300611adf3183a655410bd6ef03e29d"
    sha256 ventura:        "f8d47b9883d1c2a1c45d7bed09494f7586f903a9fdd492ecea864a666ac389d7"
    sha256 monterey:       "571c6cad8255fa76875b1cf3a2de4c1b29bc96dbeed928710976985deb6a83f7"
    sha256 big_sur:        "09e06c5018304168b8a34636878fd67855ba2968023a1b0099e94ff4bb411089"
    sha256 x86_64_linux:   "d54988d4cf61c042a4056afed56892a31a9cb136edf5be885e836f45a80726e1"
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
