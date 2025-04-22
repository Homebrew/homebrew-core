class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.34.2.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.34.2.tar.gz"
  sha256 "f98ce3c74300be05eddf05dccbdca498b14d40c289f773195dd1a559cffa5856"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f496943bca776d801cc69ed3030cbc674c2fbc0389eff638f695b254bd0c7f7"
    sha256 cellar: :any,                 arm64_sonoma:  "cdeeaa3cea7d5264e40ab92a95390e69f3a03edcb98fc16bdbb6575e0a26668f"
    sha256 cellar: :any,                 arm64_ventura: "6f9a4360b98d572185c32090f352e4ad3d3cbe454d0b91126ee6569946a2171d"
    sha256 cellar: :any,                 sonoma:        "32590d82f754c66457a2d9b9881cd12802b714d80eabc71f792a340be3e08a86"
    sha256 cellar: :any,                 ventura:       "09a70e28898fc6a10d5ec3e95b3ba90e9fe25d5115c90d5c18e68e2a71e794fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62017abdb6ff75cc096e9e953e8e663d5b8d2d2ba16bffedc0d3b88db7397b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3316437aca39c321785644e5cfc62a627c4cf9b90e7b271b339ef89c15488611"
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
