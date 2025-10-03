class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.35.0.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.35.0.tar.gz"
  sha256 "1467afb73f35e3f5d0e9fd70628c14cba266a65e2a1fb6e3f945ee3385c8595b"
  license "LGPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?neon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9209ee7b15a76a8a5d4a86450d865b1806ba45102ceb58318a55cd7499fee5e0"
    sha256 cellar: :any,                 arm64_sequoia: "d2678bf553b660959a46fa76015d02248a4bad6170c9f1f6fc431df55c385acf"
    sha256 cellar: :any,                 arm64_sonoma:  "fadf31281622306d3cb61696ecdfd8377ff16020ae06ad15ebbb2bd45a62e386"
    sha256 cellar: :any,                 arm64_ventura: "d8d09b9f936ba9af41aa655d4d518e13f4c19ec377f11810839995b27c10c10e"
    sha256 cellar: :any,                 sonoma:        "8be89f6c7690b43cad0f9fe25bb23a1be0e931e4012360ad5b035ebf5666d290"
    sha256 cellar: :any,                 ventura:       "27223b58b2ef27a340c90478e3d0c090a825775c2d7ee1cfbdd6005d0f3f9cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1452d52bbae2d279acaa6c18ff7c989a67c356c6f5b2eeebdd91df31d172eee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ae683a2e4863090997632a45ca8aca8d65c32624e18ce06ce08509ab9214b3"
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
