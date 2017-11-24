class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.17.0.tar.gz"
  sha256 "c7282fd7ccec9b8c331e7bb6d5008617f8a980e61ec5748be61c263b85efb47c"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "a8e4c3255d04586820eda4d84bd11aeb8218ba9214cc31a1981164fe1899bf34" => :high_sierra
    sha256 "4a0c5f7f66eca7b3d9b8f8b91b19284981f11b3c6e9997d1bec4e6066742faa6" => :sierra
    sha256 "cb61c78995f323e658bddd41af05955bbe64b48183ddcf1d35689d8ea29ec04d" => :el_capitan
  end

  option "with-test", "Execute compile time checks (Requires Internet connection)"

  deprecated_option "with-check" => "with-test"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
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
    system "make", "check" if build.with? "test"
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
