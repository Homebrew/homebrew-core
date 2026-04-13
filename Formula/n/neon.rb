class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.37.1.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.37.1.tar.gz"
  sha256 "a99b7262525a454d1065cf76dd17240fd808dfc4ef15636990ff83a5d0d9e740"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "656135b04dc530d4ac18b1def2648582f0ef31ca4514c9a451df1825bcc0578f"
    sha256 cellar: :any,                 arm64_sequoia: "08ecfda5a308299635e7053a865443c66ebbc143aebcba26c3ce887b664fec80"
    sha256 cellar: :any,                 arm64_sonoma:  "95ec8950f5f94037051bb97151197f090b6450cba5d4bb939c05d949ae98e953"
    sha256 cellar: :any,                 sonoma:        "7a853aea4377ef387f5865eac35a7ac76a0e19bccf8a5c25224555e0a8f56452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e555fea5f08acec473709fdb443a3706356ae0147e4b9c8c5d08a438f8260f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "336b2b3b5081772f881787ba2396b76e371e61cba9035c5233f96fcb6dea6562"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
