class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.0.1/jemalloc-5.0.1.tar.bz2"
  sha256 "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9"

  bottle do
    cellar :any
    sha256 "4046a803c804dac204126e10acd158e5a996c5bc8117917979ff495a5e07fcb3" => :high_sierra
    sha256 "0ae7f33eda0547fd2eacad3f84c3c7cc6ebfb76ea02e8a4bac542ba60ba6ef07" => :sierra
    sha256 "1e49d486784c64dccee6e43d61ecb201adf6ac8b5cc02465ac9ea5b492a56d01" => :el_capitan
    sha256 "49a8f071338b3ec42cd89280681c338ad2e1d242a389e65f63f64e60257c5733" => :yosemite
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git"
    depends_on "autoconf" => :build
    depends_on "docbook-xsl" => :build
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
    ]

    if build.head?
      args << "--with-xslroot=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
      system "./autogen.sh", *args
      system "make", "dist"
    else
      system "./configure", *args
    end
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
