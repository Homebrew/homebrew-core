class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.44.2.tar.gz"
  sha256 "e6e2ba8b4c349a4182a33370bb9be5e23c51b32efb9b9e209d0e8556b73a48da"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "746fe4eb7d0b25433f8cde56f120e78d21c4bc8c8b3430337f40fe7db5bb1348"
    sha256 cellar: :any,                 arm64_big_sur:  "6bdd017301737ede2bf71fc43bc544f7c656eaa4fd60855272b834f4371be99f"
    sha256 cellar: :any,                 monterey:       "6b121623b8a2714af980d4ce328e5d6911995d4c085ce8a42e36dcc7bc489d09"
    sha256 cellar: :any,                 big_sur:        "48d6619d98a2c6f24c02b348843c64d8c774244776ebde0cc66b9ebd3a5d1b11"
    sha256 cellar: :any,                 catalina:       "3bc297b17b73a0aa9f05e300b19fe023a37cdcd2b1a1fab7b9273d1e1b2ded1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f9a512a4aafcaa8a2a87fcf28ff838ac7634a6ab5307cc95bc800a46a49bfff"
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
