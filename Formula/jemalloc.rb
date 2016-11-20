class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.3.1/jemalloc-4.3.1.tar.bz2"
  sha256 "f7bb183ad8056941791e0f075b802e8ff10bd6e2d904e682f87c8f6a510c278b"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    sha256 "d856fb9367ed1b8bd8edf5da64a161e77c01c617f918c6d065accfde865ebfad" => :sierra
    sha256 "df966e457b7953b26a6dafbb85305f0d5b359e2f79bba4e9227a1c4fa5f45eb8" => :el_capitan
    sha256 "02fe447b5597efeed4c16daa355ba7d8bbc99607a89aafba9c4a914c90f3dd3b" => :yosemite
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
