class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.8/libhttpseverywhere-0.8.3.tar.xz"
  sha256 "1c006f5633842a2b131c1cf644ab929556fc27968a60da55c00955bd4934b6ca"
  revision 2

  bottle do
    cellar :any
    sha256 "f329514bd9a5b50bde27abe0a914072c5c32db02a3df1f76e5e6a02256493547" => :catalina
    sha256 "7ed8d7cc4934185649bb1d3efc00f0ffac955310085db2cf44434cdf476a7e8d" => :mojave
    sha256 "109e95eba0ebfe5a6d3c358055bc07861e2dce33e2376aa33843e73fba9a52eb" => :high_sierra
    sha256 "f161a27096199a9810416b47d93c1bbf95b3948641ab009a7cfb049e5264a76f" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libgee"
  depends_on "libsoup"

  # see https://gitlab.gnome.org/GNOME/libhttpseverywhere/issues/1
  # remove when next version is released
  patch do
    url "https://gitlab.gnome.org/GNOME/libhttpseverywhere/commit/6da08ef1ade9ea267cecf14dd5cb2c3e6e5e50cb.diff"
    sha256 "e5499c290c5b48b243f67763a2c710acc5bd52b90541eb8da3f8b24b516f7430"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <httpseverywhere.h>

      int main(int argc, char *argv[]) {
        GType type = https_everywhere_context_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    libarchive = Formula["libarchive"]
    libgee = Formula["libgee"]
    libsoup = Formula["libsoup"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/httpseverywhere-0.8
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{libarchive.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libsoup.opt_include}/libsoup-2.4
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{libarchive.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libsoup.opt_lib}
      -L#{lib}
      -larchive
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lhttpseverywhere-0.8
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
