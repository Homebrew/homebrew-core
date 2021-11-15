class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.42.0.tar.gz"
  sha256 "371e5419708f6aaeb8656671f89400b92a9bba6443369af1bb70bcd6e4b3c764"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b0a2b27ac3b806ff9e5949494398837a80eae0852dcf9bc4d64905f4eb4686d"
    sha256 cellar: :any,                 arm64_big_sur:  "68f6757ac44fdd21a8c3d697ca201b2063dfa2e995c783637189a4467d87f71b"
    sha256 cellar: :any,                 monterey:       "9065ec0fbc415fa235ed422edb22fd45b28d5a3207ce9e1b0565903f2ce33fd4"
    sha256 cellar: :any,                 big_sur:        "b11e3f74f2caca70d334f8d1172c50ac06d9d53018b959d8fbd0310783c05652"
    sha256 cellar: :any,                 catalina:       "98fb2b7b02c165f7a652be5a9a2d012887ca583fc27eb4ee84b61cbfae9801ac"
    sha256 cellar: :any,                 mojave:         "80f10e3328caec6ffcb667226cecd4d3bf699e1886c6a6e0915671278fd48493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43766cfe240a62321678b85556fcca67604d899cd6f93b800107feb11d5a202"
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
