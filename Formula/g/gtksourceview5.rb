class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.12/gtksourceview-5.12.0.tar.xz"
  sha256 "daf32ff5d3150d6385917d3503a85b9e047ba158b2b03079314c9c00813fa01f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "786816bbe19bc03434ec9dd26bef024e184745fe13c60dc7424b8ce8549db61f"
    sha256 arm64_ventura:  "bffd48ad9e36827a2791607346135c2bb46f4702736a5f085dce4b6f96b0f80f"
    sha256 arm64_monterey: "3b54c025d8deafb5fdb5544ea129a35b6f580e7e36066c70531cfe13a8570463"
    sha256 sonoma:         "5acbb50d1d9b0c688598043fe35e4b37b97774eab1b6039f02fa6dcdcf6eb34e"
    sha256 ventura:        "2fdfa280b3b13397b7772e67b53b8d86397a7790021491ad8f9a23b7a4394345"
    sha256 monterey:       "e77bf4aa1624231f5db2ecd713ac48fc8049a674a002175d6a7b69b465bb4daf"
    sha256 x86_64_linux:   "f0912a0d3399c70d5bf674bb254c1e98e3bf0caafae3dec7dcbe7ffd2d8efcbc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"
  depends_on "pcre2"

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
