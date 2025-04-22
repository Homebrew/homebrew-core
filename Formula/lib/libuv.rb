class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "b1ec56444ee3f1e10c8bd3eed16ba47016ed0b94fe42137435aaf2e0bd574579"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a70ed97116c4960f0484159c07145df8e768b1a62be68c071070869ba4c3644"
    sha256 cellar: :any,                 arm64_sonoma:  "b39ee9c307a07d8422f5d604b36eb61879bc1f8563bfa964bfab96fc79aaa5ce"
    sha256 cellar: :any,                 arm64_ventura: "7675ba03df1cef221fc81024c4f2efe38cc08b23903e60ee60ecb99f917323b6"
    sha256 cellar: :any,                 sonoma:        "50124229722199f08735d93a315c1a8678e19635eb31099331e608856870dd54"
    sha256 cellar: :any,                 ventura:       "112d27659fbb30ed6b607846c4ff7754526f39fe9b227a851738347f113aa65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6411aaa044da7134c5724375ed447f42a919fd4cd0598e4a197940fd04917e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06e43cd87e374d2056468b681e66243b6da9088013ab49f9838e4cd44ddfc96d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      man1.install "build/man/libuv.1"
    end

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
