class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.24.1.tar.gz"
  sha256 "0d026c8f68c4d7b7c59de8f485f262ac71c24e0f3a80d740a25d20edd2f2774e"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "09166f878502fe7c5dc957f72ab0aa41fbd76b71fcacaa18cdca50cb026a23fd" => :mojave
    sha256 "44dee19583265f99dc76919d6ddebe74b18548fa75745ed6dbda7f42ebd1dcb3" => :high_sierra
    sha256 "422da24a68929def8b2703c05b0fd1e32ecb8cdc965f34dbba60972c1e3740df" => :sierra
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
