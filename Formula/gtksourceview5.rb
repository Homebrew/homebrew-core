class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.2/gtksourceview-5.2.0.tar.xz"
  sha256 "c9b34fa02654f56ce22fa08827d89db4ba81631b2e6d7d31ea65d13c729430e9"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "195195221b285f8158d2a261d7e7b6b081a702aeac2f868e0ba7d33300589836"
    sha256 big_sur:       "ed1b0232d384c9b9aca135cacb412a53f1ea08a6c964f0911dbc0af15481b5d1"
    sha256 catalina:      "f2be3a8df55eebb30a6f873631bbb4142f51c0f99a5df55a9ba3c26ef0dcda07"
    sha256 mojave:        "2c31df3348cd823f136f70a4bf6f57a16a3b95ad819a5113aea83450f83896d1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"
  depends_on "pcre2"

  def install
    args = std_meson_args + %w[
      -Dgir=true
      -Dvapi=true
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtksourceview-5").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
