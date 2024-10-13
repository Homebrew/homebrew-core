class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "94312ede44c6cae544ae316557e2651aea65efce5da06f8d44685db08392ec5d"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c18b0e0d1e2b638d3262a848b19041fd86207cf805780ece6e8ee2808309d493"
    sha256 cellar: :any,                 arm64_sonoma:  "9c23ac1a83b934938a24173ac408644d656e353ad19bd7690cd9ab99d0fd6daa"
    sha256 cellar: :any,                 arm64_ventura: "9afefc18232568a28ca3f5c2a66237f04d778834535d3256f1ed4684fcfb063d"
    sha256 cellar: :any,                 sonoma:        "ca00d77194a448a0c5729ea0dc37924f0aac0f67098903d3863a762e5049bc98"
    sha256 cellar: :any,                 ventura:       "f93080535137e4f547afccfc47e89afd1d1b0b5ff53405c04d2931c3dd833cd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71db46a99622b9c8a1819fe0225c676c8056fc71ae3b8f003d8ed99e88b1958"
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
      man1.install "build/man/libuv.1"
    end

    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
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
