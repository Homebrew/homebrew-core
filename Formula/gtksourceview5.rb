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
    sha256 arm64_monterey: "c6bb61a5374dcdc279127477e1b1344d919759240fce65a4178edd61031315eb"
    sha256 arm64_big_sur:  "9d6e55f548b131bd4307dd9d6d81ce6560f63cc68ce3eb51ec3aa6c5d2f19aa3"
    sha256 monterey:       "6ee6023e5ea99220a203db4a789914f781572559eaecb1a127551881ba69eab9"
    sha256 big_sur:        "ff57804f66b1d5b131888e1fdef1db65f5b2b2ddef400113a0e90b29c19e34aa"
    sha256 catalina:       "db45d64faaaff7784bb1856f4af9959fb6f507f05f5e3a633eb78f0a5c399db0"
    sha256 x86_64_linux:   "5ac4cf66c7c4cf5d6c58101c3d069b82cb8a93a51118babc534846df3752c4b5"
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
