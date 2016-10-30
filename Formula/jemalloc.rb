class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.2.1/jemalloc-4.2.1.tar.bz2"
  sha256 "5630650d5c1caab95d2f0898de4fe5ab8519dc680b04963b38bb425ef6a42d57"
  revision 1
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "21ffd1b497cef703562aaddaacd02542904dfac565cb451914cea2f34e8f5264" => :sierra
    sha256 "849f114cf2ce8914d0366643b454856182f8b1abf31f38701a0bbf36fee3cf92" => :el_capitan
    sha256 "90886fb8e88457061e03693c2955163a790f223a8365584f836c924c3b92ae1f" => :yosemite
  end

  # https://github.com/jemalloc/jemalloc/issues/420
  # Should be in the next release, but please check.
  patch do
    url "https://github.com/jemalloc/jemalloc/commit/4abaee5d13.patch"
    sha256 "05c754089098c4275b460b90d1f4b94e32a2c819496187e5378e460c9398a65f"
  end

  patch do
    url "https://github.com/jemalloc/jemalloc/commit/19c9a3e828.patch"
    sha256 "b736dab20d2688d4b21b4ba4755fd19b68145b2d9ae299a1ae154e8553d9261d"
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
