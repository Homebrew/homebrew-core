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
    sha256 cellar: :any,                 arm64_monterey: "db15bf84192daac403bc4a6ec68501788cf0edce761347bb4ddaf42d4a25c5e8"
    sha256 cellar: :any,                 arm64_big_sur:  "d9cc8d8806e4b3f432d97b4feb3dda079cb5bacac1184168784ccaa0156b9eed"
    sha256 cellar: :any,                 monterey:       "395adc3a60c399d011775021a704d48162a9e7ae9907912dae88f192d133b902"
    sha256 cellar: :any,                 big_sur:        "f229ecac1c55b37d0de4c850727ef9b4e520cea3cddfabbb8947d7fbb45e4861"
    sha256 cellar: :any,                 catalina:       "9dd1df3f4e7474684f75a7a8c148374562f82f9012d7cb8f1796548f43ee4818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0028eed72f4da1419beb6f8279bb4ea39609f798fc416560fd8253fed3f32cf2"
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
