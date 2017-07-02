class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.0.1/jemalloc-5.0.1.tar.bz2"
  sha256 "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "36daad66ad661c9b32e1805979fff03895fe839c7a4e91fd6a832aa3f8d93a00" => :sierra
    sha256 "ab395122e3e65e7def1f4c5c2421a69999a163ca1a8f551d972e2af420354c00" => :el_capitan
    sha256 "85f5f33cc20dbba2ae5bc5d1b3ee9004ea2158764e8f1c14e9e1714e295ed619" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-jemalloc-prefix="
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>

      int main(void) {

        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }

        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljemalloc", "-o", "test"
    system "./test"
  end
end
