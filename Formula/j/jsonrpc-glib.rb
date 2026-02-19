class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.44/jsonrpc-glib-3.44.2.tar.xz"
  sha256 "965496b6e1314f3468b482a5d80340dc3b0340a5402d7783cad24154aee77396"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4cf100ab4d9f7d4bae7d7c1d2d0b3aba3e3cc6eb5dfa424e3556fe59ecf59a76"
    sha256 cellar: :any, arm64_sequoia: "7f8a6357e46f77559da420058dbe1b16c64713984cfe20e382958d6f4adadba6"
    sha256 cellar: :any, arm64_sonoma:  "78577af98c115dca0b45b1043be95e744667f6752d3118558855797287023ff5"
    sha256 cellar: :any, arm64_ventura: "83622b0cf9c7770f9a75b884360930c60f7feed45436e7c8c93e8a2d352e60b1"
    sha256 cellar: :any, sonoma:        "5cb416c215c9ef0cbfa8016c2b3efb37e700665c66ef542d1c5ad20e6bd2aa0a"
    sha256 cellar: :any, ventura:       "d4912dbad1101dbc693b6527036882352656aa302eb44980c704c130690d8e5e"
    sha256               arm64_linux:   "51c4cad81b4331c702366726a8473ca4eab2d8e67d6efb0c06802df66f59f4ef"
    sha256               x86_64_linux:  "2e416c81917d0ef9bd855800e61975500b2ace8ca7d224067359a138180d6eb6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "json-glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Dwith_vapi=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <jsonrpc-glib.h>

      int main(int argc, char *argv[]) {
        JsonrpcInputStream *stream = jsonrpc_input_stream_new(NULL);
        return 0;
      }
    C
    pkg_config_cflags = shell_output("pkgconf --cflags --libs jsonrpc-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_cflags
    system "./test"
  end
end
