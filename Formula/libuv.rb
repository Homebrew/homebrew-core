class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.18.0.tar.gz"
  sha256 "772f93776ba68a357b515cda1515ce898674ef6cde30826d0cac64ce9950ebb0"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "8c6e424895b27bb7a37cace49a4496523f51d6193bc1547257816d79d2283f11" => :high_sierra
    sha256 "c7ba0dcbb23958da08ac4135140633c44203750b954e1a9e4066ca06c6574c32" => :sierra
    sha256 "4e130a18f6fd6bb9832b6c714a90e051957f7a9461d7717f393f70f9fed9b4cc" => :el_capitan
  end

  option "with-test", "Execute compile time checks (Requires Internet connection)"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
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
    system "make", "check" if build.with? "test"
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
