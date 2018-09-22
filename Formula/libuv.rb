class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.23.1.tar.gz"
  sha256 "c3386003522502d712010b852008b22b37f827e207e184e3d53f0431389299c3"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "1ba1fae0b83f672467f034228ba05ef1893b70e0dc582386b3c20a693803c073" => :mojave
    sha256 "4c1257f01f449ee09433784cc60ff07aa850fce35760e69684983964ec0b57c3" => :high_sierra
    sha256 "21e4a2c9c9d7ebf61a3db5a5ca6d41fa076a3e7c6ab8decb6ef381269edab153" => :sierra
    sha256 "a0b2fd39b58ca5a8cd41d215de20ca5c1db6fe945be0af822b3feca40884db21" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
