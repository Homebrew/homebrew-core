class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.28.0.tar.gz"
  sha256 "9ab338062e5b73bd4a05b7fcb77a0745c925c0be9118e0946434946a262cdad5"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "9d11b111edd4ed4ea2b9c042b16495d5a29a1ef3d447ef1bb1742eb2eb25f8e7" => :mojave
    sha256 "afce13c14b3ae0be1208c4e5a11aec1a28d253e15c14b1e3980b4ef142015929" => :high_sierra
    sha256 "32fcc872a7d73641c41d2dbe72b3a734ed556846f59f98940d02de44a63cf15f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      # `app.info()` was deprecated on Jan 4, 2017 (sphinx-doc/sphinx#3267),
      # and removed as of Sphinx 2.0.0. https://github.com/libuv/libuv/pull/2265
      inreplace "src/sphinx-plugins/manpage.py", "app.info('Initializing manpage plugin')", ""
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
