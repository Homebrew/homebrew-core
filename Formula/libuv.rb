class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.24.0.tar.gz"
  sha256 "55587c525196a7a550fa7e5eb61794c377ec23b44adb435fdded86e8f7f31a16"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "19ed34b82d30328c701ed5f2afc11891d57143bb44d6de7349a3195d700f66ec" => :mojave
    sha256 "08024add9002d59139982c9d2c8ce8a0bf6bbbb3b9cd604850f4da964490dd30" => :high_sierra
    sha256 "4c0eb3b89b786e290c6dbc2281c698d848554979cd6957ebe15513751cffcfc6" => :sierra
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
