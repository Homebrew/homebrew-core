class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.35.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.35.0.tar.gz"
  sha256 "1467afb73f35e3f5d0e9fd70628c14cba266a65e2a1fb6e3f945ee3385c8595b"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4132cdc867b60cc78c721b5a851312d105bb30efbade9d1e1c2b41a95d7d1c68"
    sha256 cellar: :any,                 arm64_sequoia: "d44eb24d6ae64fd82eb1e0620c3a44d1192b37981022c1195e07cc48c871cefd"
    sha256 cellar: :any,                 arm64_sonoma:  "72cc292b6a0ad843804e6a7dba94da066a900fe65f9bcd4bc931d0391fddef66"
    sha256 cellar: :any,                 sonoma:        "cb4e3d7cc5a9cbd305804080418355d0ce1ccc11d08ce98125030301868e4dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6252771625091499a4f4631867f91e64c93062de344cd19adb17634c68e53fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fbe7e80c737402218acc6a28e582b319dd2341509d92230f2f68629f6b29c34"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <ne_basic.h>

      int main(int argc, char **argv)
      {
          char data[] = "Example data.\\n";
          ne_session *sess;
          int ec = EXIT_SUCCESS;
          ne_sock_init();
          sess = ne_session_create("http", "localhost", #{port});
          if (ne_get(sess, "/foo/bar/baz", STDOUT_FILENO)) {
              fprintf(stderr, "nget: Request failed: %s\\n", ne_get_error(sess));
              ec = EXIT_FAILURE;
          }
          ne_session_destroy(sess);
          return ec;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/neon", "-L#{lib}", "-lneon", "-o", "test"

    fork do
      server = TCPServer.new port
      session = server.accept
      msg = session.gets
      response_body = "Hello world! Message: #{msg.strip}"
      content_length = response_body.bytesize

      session.puts "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: #{content_length}\r\n\r\n"
      session.puts response_body
      session.close
      server.close
    end

    sleep 1
    assert_match "Hello world! Message: GET /foo/bar/baz HTTP/1.1", shell_output("./test")
  end
end
