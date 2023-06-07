class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.45.0.tar.gz"
  sha256 "458e34d5ef7f3c0394a2bfd8c39d757cb1553baa5959b9b4b45df63aa027a228"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f5bd687771b1a8c5cad69eab1bdef215f9be9c51c85f3c9e3c31225180d5180c"
    sha256 cellar: :any,                 arm64_monterey: "709825ec0bbacec911059d28498ba06c580be5b027bb0e2140980877fcd022e2"
    sha256 cellar: :any,                 arm64_big_sur:  "29236605f4c053ccebdcc0157375150d7d90ceae25f520a34c3e0872740c919d"
    sha256 cellar: :any,                 ventura:        "ec3005a9949d42bdccb0fb020ee2fdc5e4f2b56964fdbe6c48d11249ff342d41"
    sha256 cellar: :any,                 monterey:       "25122240d73275db0db7131351164d0ebd4770c1201ea8e02566983de7c4c270"
    sha256 cellar: :any,                 big_sur:        "302e6168804f837f243dff0348f01e57aaff5fb194d8b658bf4c1c8d707e7367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "570a5b1191067938dbbfb8b38fc924492e5bc4ded8fe0ace8be2cb2241b492d7"
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
