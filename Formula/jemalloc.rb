class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.3.1/jemalloc-4.3.1.tar.bz2"
  sha256 "f7bb183ad8056941791e0f075b802e8ff10bd6e2d904e682f87c8f6a510c278b"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "10a3ed38626574621d8a49fe7f59aae9806f26faa773e5cfde401d2c508cb298" => :sierra
    sha256 "3b0c25c283146d7d7bf616fa26247464d403e7ea8a5817bb1e54b695d0d5f11f" => :el_capitan
    sha256 "dc613e55c929fa7116be676dc448b869ec87853e6598c162da00b5bbfe69052e" => :yosemite
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
