class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2"
  sha256 "34330e5ce276099e2e8950d9335db5a875689a4c6a56751ef3b1d8c537f887f6"

  bottle do
    cellar :any
    sha256 "9fbc2052929cedb26b55bf21d0ac539d8ec153d138fde9dbd57e8bf9ed943b81" => :mojave
    sha256 "8da348f2bc2a3d90e55fb0121b75e3581212e776e5f088f67be1005164917b55" => :high_sierra
    sha256 "5bf32c065113e0b07db53b73a800516a4ad8ee655cbc50596a1016101c57ec14" => :sierra
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git", :branch => "dev"

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
    (testpath/"test.c").write <<~EOS
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
