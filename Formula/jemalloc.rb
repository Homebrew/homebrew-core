class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.3.0/jemalloc-4.3.0.tar.bz2"
  sha256 "2142d4093708b2f988f60ed5fd8d869447cd9f5354933e596400c0a69bfef5e0"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "21ffd1b497cef703562aaddaacd02542904dfac565cb451914cea2f34e8f5264" => :sierra
    sha256 "849f114cf2ce8914d0366643b454856182f8b1abf31f38701a0bbf36fee3cf92" => :el_capitan
    sha256 "90886fb8e88457061e03693c2955163a790f223a8365584f836c924c3b92ae1f" => :yosemite
  end

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _os_unfair_lock_lock
    # Reported 6 Nov 2016 https://github.com/jemalloc/jemalloc/issues/494
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["je_cv_os_unfair_lock"] = "no"
    end

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
