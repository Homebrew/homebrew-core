class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.41.0.tar.gz"
  sha256 "6cfeb5f4bab271462b4a2cc77d4ecec847fdbdc26b72019c27ae21509e6f94fa"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "25ba3f6a09c7fa6c6dd3aeda7842aa95e05d3377788938ef59e71d1c504e2826"
    sha256 cellar: :any, big_sur:       "74240126a16d9be316c69535e61fd1c000428b89b6e5a8f72198dc1ce86ddc99"
    sha256 cellar: :any, catalina:      "fec3670ca2dcbe641c1351c806fa3f66f7e7054dc4d42c683d80c0dcfddf0131"
    sha256 cellar: :any, mojave:        "452550de9576d4bea5258ec6e40f345b72819f2fad1b96f2c4a71d9481c16310"
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
