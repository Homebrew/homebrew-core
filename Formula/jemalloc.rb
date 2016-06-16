class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.2.1/jemalloc-4.2.1.tar.bz2"
  sha256 "5630650d5c1caab95d2f0898de4fe5ab8519dc680b04963b38bb425ef6a42d57"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "2d9d3b8a36e1ffda6d5f4c5e1fabd95f496e4562a75cafba6ae975faa49e9bcd" => :el_capitan
    sha256 "2167fc05024156684666e97527784c9a260db0c9308e604fb27fd314e4be70e7" => :yosemite
    sha256 "5f3dbdc9c6a55e0cd7b8f53a4f001f36937d7c2f6afe92fe8cd0ce3ea39b922f" => :mavericks
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
