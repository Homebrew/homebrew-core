class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.34/jsonrpc-glib-3.34.0.tar.xz"
  sha256 "d1ceb24b503e49e7bfe6e44630c03abc65f2d047a68271eb62e332b13be90548"
  revision 1

  bottle do
    cellar :any
    sha256 "a51dd608adcefb9e3514534e49a5db64ad1e38b407b8d9349df7f3eb08bc5fe7" => :catalina
    sha256 "b0ef1160532600a75471bb0e4cc3f48e7f092111ffa7d494534e46db43accabc" => :mojave
    sha256 "298d4a37194ab19bc753bb4f7022ec0d34d12a30dd4860806582cda4406b62ec" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith_vapi=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <jsonrpc-glib.h>

      int main(int argc, char *argv[]) {
        JsonrpcInputStream *stream = jsonrpc_input_stream_new(NULL);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    json_glib = Formula["json-glib"]
    pcre = Formula["pcre"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/jsonrpc-glib-1.0
      -I#{json_glib.opt_include}/json-glib-1.0
      -I#{pcre.opt_include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{json_glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
      -ljsonrpc-glib-1.0
      -Wl,-framework
      -Wl,CoreFoundation
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
