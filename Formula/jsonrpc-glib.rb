class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.42/jsonrpc-glib-3.42.0.tar.xz"
  sha256 "221989a57ca82a12467dc427822cd7651b0cad038140c931027bf1074208276b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "92133b3379600969851a22f77764ea937b7a2c6ed7abfaace7f5d82a46f2e365"
    sha256 cellar: :any, arm64_big_sur:  "3dba2a5b06bdbc459d6fec65f00dad9f9b2882fa5a67da9a50daa8a9a5332171"
    sha256 cellar: :any, monterey:       "cd47544117766135f25e5330c9bf0d56714546c22a233d2fc958d3fad2fa1ab6"
    sha256 cellar: :any, big_sur:        "10bac873ad2f887cb49000ba547b74f3a0f415171cfc4b277ad597838ad77ba9"
    sha256 cellar: :any, catalina:       "56077dcb4a1b7160f150d9ce3fe15b7967b4575ba125be59dda49601d55740d8"
    sha256               x86_64_linux:   "f045fc3c514160508c4d033da944dfffaefa784c8646d7993e57682395a55218"
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
