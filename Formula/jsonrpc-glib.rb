class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.38/jsonrpc-glib-3.38.0.tar.xz"
  sha256 "dc5f1914a91152b70fa8fc9a11ede13148ab4af644db27a36632388c927a8a82"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "922f8e0d4df5ea8c43e188ca633694d0665046c2a364c62348c32e22309f2b5b" => :big_sur
    sha256 "06160c00773beabdcff9556c7b3cc1149b281e693807adb50afa5004999482d1" => :arm64_big_sur
    sha256 "5dcab8d9974c1bd60c225d8ce2976fd20c0cedcaf2d537a57f42fe80aec20ece" => :catalina
    sha256 "3a7318d1a9d0bee9a6b234494236778205d9dcbfb20622dbbda6c3007b3f8858" => :mojave
    sha256 "fc193951d9001132ec4fe5ee59fccae34ee8249bf51b386a52924056a0d2f333" => :high_sierra
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
    on_macos do
      flags << "-lintl"
      flags << "-Wl,-framework"
      flags << "-Wl,CoreFoundation"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
