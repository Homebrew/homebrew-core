class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.14/gtksourceview-5.14.1.tar.xz"
  sha256 "009862e87b929da5a724ece079f01f8cee29e74797a1ecac349f58c15a3cbc58"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "089a65704275a9abed6d5755ddcfc598b137e56f654d92df9044dc9ee5199f1a"
    sha256 arm64_sonoma:  "338321310c2cf103732b57df6e2339787b0639fac7adb22d284aa971415a0cb4"
    sha256 arm64_ventura: "93ef5085c82b1e3c3fd1695ba9054b21f627e444e29ceb37c7995ee7313b0279"
    sha256 sonoma:        "58c34a136f3f452f3dba0cec265440daed7549ce3076a8508e7cd9959fd774af"
    sha256 ventura:       "3bad6976cb3afd66027201a78ad8af1bceeb18d37b560588be994b1943723691"
    sha256 x86_64_linux:  "5cec825fdf9590375c3945f66fa9cfa679fe4a4794db8f7de4e546e96a04dd8e"
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
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs gtksourceview-5").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
