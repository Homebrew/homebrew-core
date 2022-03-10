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
    sha256 cellar: :any,                 arm64_monterey: "a2bb69e93486fbc690b96beee55a20ec415088331a9c0b4bad5f830654737ade"
    sha256 cellar: :any,                 arm64_big_sur:  "f33d028c1de81cdf989f86401d160c4a6f87738ec26faaf3a829c78ba58eadcb"
    sha256 cellar: :any,                 monterey:       "eed09253d2a5e9687f41d91f2ccc6d95b5064c0dde71a8ad1111282b60533413"
    sha256 cellar: :any,                 big_sur:        "712d9a2ac53d611a196fe9fad47c13a524e71dd8938f84bb0562236df717f5d3"
    sha256 cellar: :any,                 catalina:       "17eb0dfc586b2cd02388db0e9179d8cc24955e48ea4ed642eb8547fbc0b80a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a34c9636b069d23c939c28d5cc75e1faf3a6c0628126f15fc3482b7db82b7e"
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
