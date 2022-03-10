class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.44.1.tar.gz"
  sha256 "e91614e6dc2dd0bfdd140ceace49438882206b7a6fb00b8750914e67a9ed6d6b"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a6abf837a4759d19e3239f297cc91eb981362c33b138a88e72a6a980428b55dc"
    sha256 cellar: :any,                 arm64_big_sur:  "e617a6229e4ad2e275ad42a050337c94cd1460bae6ff3577afa648c4ab79f0d5"
    sha256 cellar: :any,                 monterey:       "dc579bb4254d8324ffe808d30a5fd37d5765b7f35519fa20aac07190116696d9"
    sha256 cellar: :any,                 big_sur:        "9fd9551ca3170dfb5204a8240d26b615eac2e81992a095fafce8f2b496cb6812"
    sha256 cellar: :any,                 catalina:       "f71d61e41b409e35d1eb302c2ef1641e02ae2671ebad8188435378432386e21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92c1c2f358eed41ac912bdc547f7d981926b03dc9eb593da203420e31607d7be"
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
