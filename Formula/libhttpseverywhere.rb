class Libhttpseverywhere < Formula
  desc "Bring HTTPSEverywhere to desktop apps"
  homepage "https://github.com/gnome/libhttpseverywhere"
  url "https://download.gnome.org/sources/libhttpseverywhere/0.8/libhttpseverywhere-0.8.2.tar.xz"
  sha256 "f00dba729feaf6fed9131fab482be888e1b4a45dbd100497dc9e69e6688d966d"

  bottle do
    cellar :any
    sha256 "a197df4768540d38537b992a5d3c53754a845da7d2ad0c82d2fc587023c562f9" => :high_sierra
    sha256 "e4b23d5d0f44f0ea5dcd3c68c615ce0b633c8ce850826274936b67b9dad7ff86" => :sierra
    sha256 "2bb56acfae21609406f56ff79d97292fb687b762401be0a62eff1a73ec0d2489" => :el_capitan
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
