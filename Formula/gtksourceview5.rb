class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.4/gtksourceview-5.4.2.tar.xz"
  sha256 "ad140e07eb841910de483c092bd4885abd29baadd6e95fa22d93ed2df0b79de7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b1d74a6f11921a7b5342cb6a13d9844f2d7a386e007898d6d2b8ed42eb3c34cc"
    sha256 arm64_big_sur:  "ed2ee55267fff8dc6fd7cda2a9476f1df8381ca7b1c613c79922d9b04d498222"
    sha256 monterey:       "80bc49c0724b52c629be92f9906972bd92d357121fb9efdadd57ea0079cdff15"
    sha256 big_sur:        "6f39e589eb19862e381e2bb11991e7ddf49e17fbcc29a983133605f003b1a38c"
    sha256 catalina:       "bdfe0e885323e16470375a341dc6e8497962e29b19574cc3e7a823a306040f9e"
    sha256 x86_64_linux:   "608137a1741c27cea2f24260a4c85eacc5b35062ce04fd12d90214d217652eed"
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
