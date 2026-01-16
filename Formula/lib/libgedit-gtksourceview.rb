class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.6.0/libgedit-gtksourceview-299.6.0.tar.bz2"
  sha256 "e0c79788f548dbc94f932faaab91ef823a9e9d336ef6f1f049623116121d2e75"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "5b6c9b17b3bb740501d68195ec792ef4c9f5840675852a5f2920afdc5592d8e9"
    sha256 arm64_sequoia: "dd34f4f25b8feb6ca0d6099d24b74b7745b8c9126e5186505606e54d8704a21e"
    sha256 arm64_sonoma:  "bf9839b6b443329ef775e5e23fb32bc5bd358a6e5aa1c0c9e4a05efcf3f01819"
    sha256 sonoma:        "9243c6e8aca52ab616b575c01152734b3363b0dc0cfdea63139951dd1101ec53"
    sha256 arm64_linux:   "bba43ae578b878333c48f22d8a8aaafcf5a8fb851ec97850a5ace0f38ae6f0d1"
    sha256 x86_64_linux:  "dc9caa68f0e8cd1d3781419a388c021a54ed8e717a222ebe4df2e496135134eb"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
