class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.4/libhttpseverywhere-0.4.5.tar.xz"
  sha256 "426ecadd125c22cf5197001d6e78ce0fba23ddd0599f5932e689e68204674f1f"

  bottle do
    cellar :any
    sha256 "3e77a83c87ca574213b6288724d99d3f62985e71a2d843f93171b4057600f557" => :sierra
    sha256 "b7e3be38b435a95ddaebcfff5a141b3c1caa1a3bd31a3ab8d33773a4f3e1c934" => :el_capitan
    sha256 "1cdc86e9997ead1ce78847880ce213bd47e5a28e403c273cf6449f804c71854d" => :yosemite
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
