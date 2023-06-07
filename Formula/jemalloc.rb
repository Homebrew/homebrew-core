class Jemalloc < Formula
  desc "Implementation of malloc emphasizing fragmentation avoidance"
  homepage "http://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2"
  sha256 "2db82d1e7119df3e71b7640219b6dfe84789bc0537983c3b7ac4f7189aecfeaa"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33e0c3fbe56642e081018a9674df734d34afdc35af7d03f5dd2b484a804555e3"
    sha256 cellar: :any,                 arm64_monterey: "b7ef9abad498e6eb53fb476fde4396fc9ab99a23092ea14bcf576548e198f9bd"
    sha256 cellar: :any,                 arm64_big_sur:  "b24e4a9413b347397a10ebc9a7a2d309d88c0f9479c1cdebe6c302acba9a43a9"
    sha256 cellar: :any,                 ventura:        "66b5f3a4c4ad9f7801e6ad2e76d1586e7b57e2cc64b24c2684dd1c2af8bc82f3"
    sha256 cellar: :any,                 monterey:       "27ae29c02d718c38ee5f623c3ef08ad3530a6fd3595d16d2ddadd6552bf32c12"
    sha256 cellar: :any,                 big_sur:        "72aef17aa140b457400c4f2b74d0473bf1160616c3df7cb8604ac2bf734afea5"
    sha256 cellar: :any,                 catalina:       "3f5cf334d16ab432bf210c7e171510d0edcd834f939b57bddfd428af5ed248ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240b20cc078b21d90c32bd34447952b9b464958b1858ae109f168558993f9278"
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git", branch: "dev"

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
