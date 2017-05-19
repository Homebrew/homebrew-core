class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2"
  sha256 "9409d85664b4f135b77518b0b118c549009dc10f6cba14557d170476611f6780"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "c79ef4c7da06c83813e093d60a8580b89a40595bed59f10f3063f30b5a842b0d" => :sierra
    sha256 "d8e3b7fc7660d387e979652d634cd4d538e4da972b77df1e781bd9e1e4cb9c95" => :el_capitan
    sha256 "531e1af9601b711780d0a5e1ebb6104ef6e1b63eb2ae41f9a4597e67896ccf1c" => :yosemite
  end

  # https://github.com/jemalloc/jemalloc/issues/420
  # Should be in the next release, but please check.
  if MacOS.version >= :sierra
    patch do
      url "https://github.com/jemalloc/jemalloc/commit/4abaee5d13.patch"
      sha256 "05c754089098c4275b460b90d1f4b94e32a2c819496187e5378e460c9398a65f"
    end

    patch do
      url "https://github.com/jemalloc/jemalloc/commit/19c9a3e828.patch"
      sha256 "b736dab20d2688d4b21b4ba4755fd19b68145b2d9ae299a1ae154e8553d9261d"
    end
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
