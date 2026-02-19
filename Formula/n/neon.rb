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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "30ba4e84e339e497e1fe0933a8bf18073e732a580d5a780e344e2ff6f4322418"
    sha256 cellar: :any,                 arm64_sequoia: "75aecc98faa1ed5f176c8ea3094179152f916525e3239e2ee21ff44867a5a223"
    sha256 cellar: :any,                 arm64_sonoma:  "dd3284af74c1f672db2340c11a531661efc6a015b751d1740ce4d9e082ae59a1"
    sha256 cellar: :any,                 sonoma:        "006e4f3e377aad08164df051a21403b679ee0f0117c2799a566f85bc918e1b88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "114a10ae6f014a154425402e4cd3d3b209620c5cb4e264a472d1ed5d9e97f9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b122d373423865c5baf83761cb9687cc7a5f2885f3dd7dfcec2ea304cb88d6e9"
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
