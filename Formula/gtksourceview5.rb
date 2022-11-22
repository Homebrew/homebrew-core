class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.6/gtksourceview-5.6.1.tar.xz"
  sha256 "659d9cc9d034a114f07e7e134ee80d77dec0497cb1516ae5369119c2fcb9da16"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8500a38bde8f2362eba345a641ef494181ca8f9ca9d371d8c3eb5390cb3e447c"
    sha256 arm64_monterey: "95ecf13f25c7b6dba6ce922afea5933b2932d0bc099a69a7c11fff678afa3a53"
    sha256 arm64_big_sur:  "e89bff5608ef32a1e086e088a952f4cad107ea93889b8d50300c4585743bd021"
    sha256 ventura:        "f8d9d594914e7ad2d94fb44d99a530dcb252e1a02d93dd19a09207dc90a75b89"
    sha256 monterey:       "9ce97c46b9e259a2650e6afad120346ce35b979d781a57352134a877fc8d386e"
    sha256 big_sur:        "326a12dd4ed21e70aa71a5e56c85fd10d0bb88f18f5a550037a958b0ad6af293"
    sha256 catalina:       "b9e031a18b4e9ee7cf66a18f241cb0f589da07639ccc0ee4874b3fb12c32440f"
    sha256 x86_64_linux:   "c8ea21321b5ea9dc065b15eae4d2fd955194146383b14a4640795d6743ce541c"
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
