class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview"
  url "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview/-/archive/299.2.1/libgedit-gtksourceview-299.2.1.tar.bz2"
  sha256 "b183a816f3958df4bf5e186fef6f9a9e31d7747e6fafecc5cf1650b4807920b5"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "f90702eb564b47f8de26d4e7ae85f97ec726febfd1dfb33726d4d64de813dbd5"
    sha256 arm64_sonoma:   "5aff961bf40184a0c661fc7890f4b2be98937d7eb417ee76429a99e1e147ed76"
    sha256 arm64_ventura:  "ea3c2abf6e495e0bb8ec265fccee3d2131de9fd210c556fa30790c610483742e"
    sha256 arm64_monterey: "d18303d09984f7b23c1cc53aef7ed7c7171b4d7ed78eb2edf55ae1696725abe3"
    sha256 sonoma:         "1e214228a6d3f1c415827dae97d0c9318eb1db780e0e598568cddd9759bf5a54"
    sha256 ventura:        "616d3ed819468270727c83c8d3bd7e7d38290697e24991c366100408d10ff319"
    sha256 monterey:       "7b81052f99056209550d3a2149280b976f03ff6f0dc4d056e060065f4d231fbf"
    sha256 x86_64_linux:   "528ce89f65e7be3f6184df2d3e64ec16c9e733ac55a5e3722b55088d386c4d80"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
