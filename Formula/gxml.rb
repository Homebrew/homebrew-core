class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.20/gxml-0.20.0.tar.xz"
  sha256 "0a0fc4f305ba9ea2f1f76aadfd660fd50febdc7a5e151f9559c81b2bd362d87b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "7fe768a5398f9cb19eb57263e3b9b57716b48a149b175ff9b970eb1e898fbacd"
    sha256 arm64_big_sur:  "33e373491cc352e2b11da05fc36b7c9e66451efcbee7b10c06b8454bda72b92c"
    sha256 monterey:       "79846b0652593f371cdc95ad36d037c58b51db809b5a0bb6baff00afee0a0c12"
    sha256 big_sur:        "93014bd6358485893840d5e1fcb66bbb2b9528c342d5d38e08525ffd6c8dfd4c"
    sha256 catalina:       "7ac6b48935cda53013a788e02cb0169fd609589beac7b1af2ad6b3b64e3045a2"
    sha256 mojave:         "656bfa0f89deba237c40af306b141291c548befeadd268d7aaca198db78afe91"
    sha256 high_sierra:    "c206e3ea69e32dce78804db3d9e0ab2d10a441a4677614324fd46e1e53bdb5e7"
    sha256 x86_64_linux:   "e0fc25edebbe9a8fe4ac0ef484870d6f3481ff6d467314b793a933b66b32bcab"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=true", "-Ddocs=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    EOS
    libxml2 = Formula["libxml2"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libgee = Formula["libgee"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{libxml2.opt_include}/libxml2
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gxml-0.20
      -I#{libgee.opt_include}/gee-0.8
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libxml2.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgxml-0.20
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
