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
    sha256 arm64_ventura:  "ea019efaff6facbb5914e7919783a893ef3406c9320ac6eafd8bf0191385dc83"
    sha256 arm64_monterey: "1aed02642e163cde0301abb659b3ca20f5d080886dc2b348335b5267fe2ad96f"
    sha256 arm64_big_sur:  "1d6640782a409f8675e412988cb679f069ec57c0fa5ee69d29602decdc17bc78"
    sha256 ventura:        "9e38e2e5b689f987c9806e7fb8a550f2f67e7fb3e51a46a86d95705d218df4c4"
    sha256 monterey:       "b9ae3db42dcf5b04fafe8f4411c58c2f2d9d54ef7ad6422b630eeedec692da33"
    sha256 big_sur:        "49585cdeed5f785186a84cd901db5b850059d7ef50e4422eed1c93bb8c0ff32c"
    sha256 x86_64_linux:   "1bc2706aec7338fd999d46e0158d5c234340d8c297d040ea0da8a12543ba3747"
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
