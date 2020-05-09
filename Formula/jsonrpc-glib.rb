class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.34/jsonrpc-glib-3.34.0.tar.xz"
  sha256 "d1ceb24b503e49e7bfe6e44630c03abc65f2d047a68271eb62e332b13be90548"
  revision 1

  bottle do
    cellar :any
    sha256 "1c302e75c1276b6fac906158727353657f8a6a353ec9a395ecbae99a5025dd18" => :catalina
    sha256 "42081e5890e3bfe1be1d29bc08d2ca9376d9e2493c0a7f1828497e59ffa8cc54" => :mojave
    sha256 "7fc3931e31121ca0f83710193591bc1ffe2fed9c9300aedead32db047b39e940" => :high_sierra
    sha256 "b47f0d67cfe99c39b1d789aabcc4e19384afc7477273687b46e359064f79fa32" => :sierra
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
