class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.34.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.34.0.tar.gz"
  sha256 "2e3ee8535039966c80764f539d5c9bfee1651a17e2f36e5ca462632181253977"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3ad7595a5c35b65ae30a7a6da4af3124f99907e61ef39b1b6e42672b342d7006"
    sha256 cellar: :any,                 arm64_sonoma:  "211823aacf5a9e2f6cce95bc4f813531543109f017757a4672780556cdec5697"
    sha256 cellar: :any,                 arm64_ventura: "fd439277f4729eb9c1ca39cdb7d7fa9d7ebe00c61cc37ae666448a378ac6d956"
    sha256 cellar: :any,                 sonoma:        "37ddad09a125b10c53fd3c2207a698600fd89284c1471280e8f9facb0c74e630"
    sha256 cellar: :any,                 ventura:       "39170f9978a9ea387e608c9972e71238b682372da5c1d558038526baa0204120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2838b2603a6c1e6eb405f56f1e7903a5f543a30526e7a1316c3288be9f2a479"
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
