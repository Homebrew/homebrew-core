class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.14/gtksourceview-5.14.2.tar.xz"
  sha256 "1a6d387a68075f8aefd4e752cf487177c4a6823b14ff8a434986858aeaef6264"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "8e7b457b726cecea1397e9efd17579b64faedc34e59efeb73648f8b17632182d"
    sha256 arm64_sonoma:  "82586d2cbf7e1889778914961a2f8015a152e73cd1d200b4c438f9c097d8fc7c"
    sha256 arm64_ventura: "ab0c6f4f620e38b3a0b5f7d6df316d8f2dc83b573631df9870dd7c4bb512edf4"
    sha256 sonoma:        "e53ce56cb7033ef1acacf2364aa74151c972a255278c699119320df4f30b0a54"
    sha256 ventura:       "5a7ff7d2243e7fdf95133bd9d5b8f1502de0df547e33193b83881166fc07d34f"
    sha256 x86_64_linux:  "0f74870b529aaa99c3bd5c038ac5c9a5f230fca1d1345ce431bd706ae32e1049"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "pango"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
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

    pkg_config_cflags = shell_output("pkg-config --cflags --libs gtksourceview-5").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
