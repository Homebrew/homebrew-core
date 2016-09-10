class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://www.canonware.com/jemalloc/"
  url "https://github.com/jemalloc/jemalloc/releases/download/4.2.1/jemalloc-4.2.1.tar.bz2"
  sha256 "5630650d5c1caab95d2f0898de4fe5ab8519dc680b04963b38bb425ef6a42d57"
  head "https://github.com/jemalloc/jemalloc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "70c10932afc1f99132505300ab9b4b9bee66713b767da3ea7e78079cdf970de1" => :sierra
    sha256 "3a7d4d62fa79b02d9497ce12996f5f3184d40ef982c7d33c141c553e85570658" => :el_capitan
    sha256 "b9f4ef12ac5f78f0981f728d955a6d70b3a7fe952ea967433178addc30291669" => :yosemite
    sha256 "c6f28a796d10776f88c9909ece4cd3baa832d2f90bf654a49c8b7a0811597b35" => :mavericks
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
