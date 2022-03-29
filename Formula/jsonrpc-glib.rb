class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.40/jsonrpc-glib-3.40.0.tar.xz"
  sha256 "c2e3d16257c7266cd3901884e22375575bf61a8e1f67596c88e0d87ae70d0ef4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b840c82daeec35544e1eddb0481a5a6300f867e853859b557c2cb3f0d4e19ad3"
    sha256 cellar: :any,                 arm64_big_sur:  "69e3e97a9a4193dd6f3a23b11166ea27cb99760931244f6a391a228bc4eca196"
    sha256 cellar: :any,                 monterey:       "f25b784b62fa80160800aad053d3b1bf13267135cc0cf56908fa0142075580e2"
    sha256 cellar: :any,                 big_sur:        "ec54de6bc6799ae0b497447de9d3dfe5b4f88ce71d3a826da43785affae68429"
    sha256 cellar: :any,                 catalina:       "ea6e41d579c3e4d3dc33355b3de46277d6605822a78f2f395e329329155a6bf7"
    sha256 cellar: :any,                 mojave:         "ae9d2d930e0b55dcd99e9ed1188d5a4a7adf4523851feb1fb1a01ff15d9de575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50fbcd7be2fa9c83aa93fd742e8c678998494c03c27223d47fafb50fbe0f1fe0"
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
      -ljson-glib-1.0
      -ljsonrpc-glib-1.0
    ]
    if OS.mac?
      flags << "-lintl"
      flags << "-Wl,-framework"
      flags << "-Wl,CoreFoundation"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
