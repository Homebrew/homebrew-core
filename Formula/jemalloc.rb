class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.0.0/jemalloc-5.0.0.tar.bz2"
  sha256 "9e4a9efba7dc4a7696f247c90c3fe89696de5f910f7deacf7e22ec521b1fa810"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "c79ef4c7da06c83813e093d60a8580b89a40595bed59f10f3063f30b5a842b0d" => :sierra
    sha256 "d8e3b7fc7660d387e979652d634cd4d538e4da972b77df1e781bd9e1e4cb9c95" => :el_capitan
    sha256 "531e1af9601b711780d0a5e1ebb6104ef6e1b63eb2ae41f9a4597e67896ccf1c" => :yosemite
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
