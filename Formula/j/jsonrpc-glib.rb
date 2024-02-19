class JsonrpcGlib < Formula
  desc "GNOME library to communicate with JSON-RPC based peers"
  homepage "https://gitlab.gnome.org/GNOME/jsonrpc-glib"
  url "https://download.gnome.org/sources/jsonrpc-glib/3.44/jsonrpc-glib-3.44.0.tar.xz"
  sha256 "69406a0250d0cc5175408cae7eca80c0c6bfaefc4ae1830b354c0433bcd5ce06"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c86b5751c59cc742957f0efe1887465fc41051068be5410b1d6dc136bbb703c2"
    sha256 cellar: :any, arm64_ventura:  "81179b347f42fa5088707b190fc8c44cce5b4674a95d99124d15e17f55e07c64"
    sha256 cellar: :any, arm64_monterey: "b9968d2db4506aa9493ae18baa2baf3606b94a270910fdc5d4a3928f6a1eb26f"
    sha256 cellar: :any, arm64_big_sur:  "7a93842a0f8c1f9d2e926fbeca2ba17d176616e66b29b26fe128f5d1e68730bc"
    sha256 cellar: :any, sonoma:         "1b93a571974779646424517cdaae6efe3c9de77ee7ae4ca3c0a210c8f591dd63"
    sha256 cellar: :any, ventura:        "1a7c09d2663ff3df9280511655b194ced292b3fdc366fe502bfee8105978525f"
    sha256 cellar: :any, monterey:       "4c5889ec718dd7362a9593d3d4be9c76a12f2252e9eda92b165e945cd8883080"
    sha256 cellar: :any, big_sur:        "5f6b0972656e86a895a4026f5738416eb37b798792adcd30edb4ad3868a8bb05"
    sha256               x86_64_linux:   "03191c798dee38b9983e2afb84310debbbd3850b21ad675b6629aa9e8cd677cc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"

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
