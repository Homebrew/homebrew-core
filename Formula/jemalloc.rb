class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.2.1/jemalloc-4.2.1.tar.bz2"
  sha256 "5630650d5c1caab95d2f0898de4fe5ab8519dc680b04963b38bb425ef6a42d57"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "85c715efc55018eb922c060e0d4c89bc9f8fcd9856899e64d47534684de7a369" => :el_capitan
    sha256 "bc589adc0101f583c28c173413d238c9d67f71d40334c1f4be7cdff992d0a12b" => :yosemite
    sha256 "fb154c600464d8fce9dd41b9494246721d02a87a528fcb097276708c9f7de72f" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--with-jemalloc-prefix="
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
