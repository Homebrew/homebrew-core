class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.4/libhttpseverywhere-0.4.5.tar.xz"
  sha256 "426ecadd125c22cf5197001d6e78ce0fba23ddd0599f5932e689e68204674f1f"

  bottle do
    cellar :any
    sha256 "c72b32519161d1da678d33eece07e1bd6aebe2a5e023e63d2cd2074754a7ec5a" => :sierra
    sha256 "4272c5bf990c67a2f2c5b7315784565ea32fb8f8d5a6fac6035aee8b4158da11" => :el_capitan
    sha256 "471090f365e9895583a1bf0e6bbcf8f4f4cc3355f1804ea30a88d3e236e26a85" => :yosemite
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vala" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "libgee"
  depends_on "libarchive"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "test"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
      -I#{include}/httpseverywhere-0.4
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
      -lhttpseverywhere-0.4
      -lintl
      -ljson-glib-1.0
      -lsoup-2.4
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
