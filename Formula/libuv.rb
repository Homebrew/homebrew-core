class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.35.0.tar.gz"
  sha256 "ff84a26c79559e511f087aa67925c3b4e0f0aac60cd8039d4d38b292f208ff58"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "f9e218fe31eec56662a5a10b0e736ac4de35d3fb22f0faa4a1c6b6fadf923b09" => :catalina
    sha256 "e5d3596b963e5ee7fa09db56190768d6b12c249485c79558e99ec69415e8ac84" => :mojave
    sha256 "33e80baa14f51bbf8944935e7291472baa5a430861a39ebb6f134ecceb20aec9" => :high_sierra
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
