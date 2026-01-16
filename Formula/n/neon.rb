class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.36.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.36.0.tar.gz"
  sha256 "70cc7f2aeebde263906e185b266e04e0de92b38e5f4ecccbf61e8b79177c2f07"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d24e6d4a85eedc5d3e115e585075840bf3687cc48031b8a1fbab682b21a4302"
    sha256 cellar: :any,                 arm64_sequoia: "457b1f8bdf13be7880864513ab979fed41850619a84251b7e423fb37c7c11c9c"
    sha256 cellar: :any,                 arm64_sonoma:  "eacd2712bf83e32b980871881b39dcb81f913d46bd9beeb00ccf7f7e7f23919c"
    sha256 cellar: :any,                 sonoma:        "267c2a5593558bf587b795fc7d84f0611a93faabcd96061a5b3786adca45a526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97b5dba9ec6a14e4083d43f7d0855eb056b1f08e4265685615e25a70142a2599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f194476fbe5b1d585ac0e4cb3f02befedb39f724f9bae67d83c01d2a6624fbe"
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
