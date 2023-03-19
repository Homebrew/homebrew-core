class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.8/gtksourceview-5.8.0.tar.xz"
  sha256 "110dd4c20def21886fbf777298fe0ef8cc2ad6023b8f36c7424411a414818933"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b4a05aca3094980009eb6b8baa31cf78ed70bc04d028a28bdf19bf02cb1c1c22"
    sha256 arm64_monterey: "415fa593676498627c5d079bd4071169c4b0efe8f4aeaf4f19aec9bba765a433"
    sha256 arm64_big_sur:  "9855c6bd1607fb74ad27750ec0703e2c341906486eed08692b38915ae54c560c"
    sha256 ventura:        "d467af830c910703728a374a5bc8a81681c66b8f14c7202a1fd10bbd11860e16"
    sha256 monterey:       "4535fb5d6950fa716efd0d2b8cd86fb207f14c75bb302697988f0ccfad2783e2"
    sha256 big_sur:        "cca04854d2481bee15975cc84547057dd18088d605943c84bbfc2e38afee0f6e"
    sha256 x86_64_linux:   "52ab5d38daec7b0e7d08518dc0bf6718f4d9d963fdc5d7bbafdc8e808c61238e"
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
      -Dintrospection=enabled
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
