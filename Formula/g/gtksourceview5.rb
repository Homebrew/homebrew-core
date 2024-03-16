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
    sha256 arm64_sonoma:   "1ac4ed566b842c7f3208d10b3824e02ee0598ed5e23b5107834d9559494a6e93"
    sha256 arm64_ventura:  "2cce39cb260822ecb6995d7f0533df4b61f312248e1ccb494dd73fe4a32292f1"
    sha256 arm64_monterey: "af6509c2c368a83453961feea538fff54198a0b9a751d63baa03c5eba7dab790"
    sha256 arm64_big_sur:  "c2d27258f21f8487b937989b846bba7deb0d000bebedca73247434ed3dbb2073"
    sha256 sonoma:         "6731abcd2f86dd1b0ff36674450c48575c176132abaea9e069b81c555fb7c940"
    sha256 ventura:        "cbd0420335ccef393978ba5b546407e1522b3de54a6dafbe18baef3e00a3240f"
    sha256 monterey:       "c6524d3679f3458b98805ab024354779052e93f44a5e170d2458a4ba40600d8c"
    sha256 big_sur:        "254f81f448773bb659113cccd55b53938ddc7f31b583f546335ffc214d41824d"
    sha256 x86_64_linux:   "b257c6940131db2d41b2dfd926101cfd67a986b68aa0053dea17d67119949129"
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
