class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.44.0.tar.gz"
  sha256 "f2482d547009d26d4d590ed6588043c540e707c833df52536744cb9a809e6617"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "729b79258effb55f6d0299e1a9183374c18f9b7a6b952285c77c9824151d62ab"
    sha256 cellar: :any,                 arm64_big_sur:  "879a2b183bb839026d2320c121ae6144abd3862a340a4ffa8d2030ec1736fe45"
    sha256 cellar: :any,                 monterey:       "0544ef6db3658b228088960be43db6018a5223a09cb7c577d361c017bb1b0419"
    sha256 cellar: :any,                 big_sur:        "bfc5b2597304936e050797edb6831d61867cd6e22ec9751dbfb391bd96e6ea84"
    sha256 cellar: :any,                 catalina:       "a103bf3322d5cc7506f727ed4d20d3f4c90fc5cc68f004cdb7c45b7b689c69f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b40de630a921e31ff5484dfe52547938a8e6f937fa9990340133b55d99ebc8d"
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
