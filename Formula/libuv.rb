class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.16.1.tar.gz"
  sha256 "61f7937eef924da0dc386c038b8a4e1fc4f1803af966e1ecf640fb0e1cb5043b"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "796593e30461af1e8f2c4559de6460697725d9f42d8fe3fa9370a3aafef47782" => :high_sierra
    sha256 "7b7f199afc57a77ef8d0ded0c0f5f4abaa033676f006fb84f78ba7a3a07d48bf" => :sierra
    sha256 "0af20d131bb5bc512e0130158a1ebfaac79868a1c3af712b026cfc8c24f303b4" => :el_capitan
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
