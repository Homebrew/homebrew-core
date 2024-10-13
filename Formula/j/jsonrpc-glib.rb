class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.44/jsonrpc-glib-3.44.1.tar.xz"
  sha256 "1361d17e9c805646afe5102e59baf8ca450238600fcabd01586c654b78bb30df"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "86e923e83351dc15ea3f8e42f004b43b42ccb4948e77d5765130f30c119c667a"
    sha256 cellar: :any, arm64_sonoma:   "2f74a9be30520cf2db1b7bb27ec12561b14d77dad8673fde2b3ca360d7c60388"
    sha256 cellar: :any, arm64_ventura:  "c4a222df659e62204a4d37afe1e07a380b2e1418cc2a99b9a445d3a5a3a77238"
    sha256 cellar: :any, arm64_monterey: "a820e5106b6a5683afa616cc68aa1dd09a94fa48a47c154ebb8fc3b3c6ae5284"
    sha256 cellar: :any, sonoma:         "001dd9f46c106194cdb65ab86ca327af3639d88d7e569339d972f0989204c5b8"
    sha256 cellar: :any, ventura:        "327ea36ff03c446861852f77250db9c4aaffd6c63bb0538d2af0a274d7f2e300"
    sha256 cellar: :any, monterey:       "d6b2438a15f0a4c0dfb464bbc5cfa277deadad086bab02da55d453d6eb1f8c5b"
    sha256               x86_64_linux:   "a4403578f986fa53a5f8c41444aeb7ba65f34e2e5685ab58c0424457c2f2eddd"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
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
    (testpath/"test.c").write <<~EOS
      #include <jsonrpc-glib.h>

      int main(int argc, char *argv[]) {
        JsonrpcInputStream *stream = jsonrpc_input_stream_new(NULL);
        return 0;
      }
    EOS
    pkg_config_cflags = shell_output("pkg-config --cflags --libs jsonrpc-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_cflags
    system "./test"
  end
end
