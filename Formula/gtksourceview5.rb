class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.4/gtksourceview-5.4.1.tar.xz"
  sha256 "eb3584099cfa0adc9a0b1ede08def6320bd099e79e74a2d0aefb4057cd93d68e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "36357bbb784bfab0aa820c5b605b2e6c1b9dda91c0c2df47a404eb1b0a1b0d03"
    sha256 arm64_big_sur:  "80d60b89081895330908e631f4758e95cde7f64ee3d14ff7d02548dc2624b841"
    sha256 monterey:       "36c5f469f7f53fe0c2daa323e2222caad12f228fbfb4836b87a6506305169c4b"
    sha256 big_sur:        "33996f93915eb6ddef55c616a060ca6505a2d8815c5ec6aed2dbf7292b951dbe"
    sha256 catalina:       "dd9554ffddfe95ecd3eeff4de2358532f60bb331f4521634fbf0589b633c5af9"
    sha256 x86_64_linux:   "1a5f46d4d0752a55b9d9d2ae9142b271fb082c944f116e06b3461c40d21878fc"
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
