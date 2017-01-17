class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.4.0/jemalloc-4.4.0.tar.bz2"
  sha256 "a7aea63e9718d2f1adf81d87e3df3cb1b58deb86fc77bad5d702c4c59687b033"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "5fe917ec03daea84cdc3fa5bf8e40ca7095b508a1496bf0de79ae436713d2938" => :sierra
    sha256 "75f73d4fdcca91df71c9e420cba44dc32d5aac158a43126610088a395e542559" => :el_capitan
    sha256 "1502e8720863b1cab829ff3fd46c497100b4da13099558e04b239fcec2d65533" => :yosemite
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
