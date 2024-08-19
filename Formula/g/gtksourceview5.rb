class Gtksourceview5 < Formula
  desc "Text view with syntax, undo/redo, and text marks"
  homepage "https://projects.gnome.org/gtksourceview/"
  url "https://download.gnome.org/sources/gtksourceview/5.12/gtksourceview-5.12.1.tar.xz"
  sha256 "84c82aad985c5aadae7cea7804904a76341ec82b268d46594c1a478f39b42c1f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtksourceview[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "8adfea87d584da20e23a23c94ec2af6846d32ba746f51c2bfa606eb665e1ecbd"
    sha256 arm64_ventura:  "9c5340e8b3fc5ee6ad0fcaa7f532e0233136e88739983f77adc1c1701e3fa747"
    sha256 arm64_monterey: "7d03cb0bed2f9783fb860c95335bad0f18e04d461973673a671c88800b43a380"
    sha256 sonoma:         "2635beffc5111372cc0595af6d7054cd5350c52aeb3f73a762fc66fb5b983619"
    sha256 ventura:        "2d3fd2deb3e7eb79d107dac69686e74edf3808cb39f2c59e6cdb557ac8bdb6e4"
    sha256 monterey:       "c629b5cd4fce80fd90d77f645b12c688651ac00b02d2c48216f0a42bfc155d81"
    sha256 x86_64_linux:   "96f6ff7d81b628f00bace8723469e5bb58033e10f8a685dac576a045bc700a02"
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
