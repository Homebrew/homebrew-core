class Liblzf < Formula
  desc "Very small, very fast data compression library"
  homepage "http://oldhome.schmorp.de/marc/liblzf.html"
  url "http://dist.schmorp.de/liblzf/liblzf-3.6.tar.gz"
  sha256 "41ed86a1bd3a9485612f7a7c1d3c9962d2fe771e55dc30fcf45bd419c39aab8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "83b34b4b95753d9be2ae3abadf136d21d850561ca2e0b1473f560cf78153cff8" => :mojave
    sha256 "cc8f446e597ea18f409543897acf2b9704779db4904ed833d66469e09fbf0301" => :high_sierra
    sha256 "b5871cec84c0cb00b6a44fdce75ee519b243d3ea1f048b5634082279bf9234ed" => :sierra
    sha256 "1319038c7de754dd38b22ec45b616419b60a0a8c19072374da01f5ee48f9e8c8" => :el_capitan
    sha256 "1d8f96a8336407a1dd20adb305d6ecd7b1d534c0c2e9015596cb4259ea368eb1" => :yosemite
    sha256 "025ca90ede89fa17407e1aec34f3a7cf3d91e414c2d629401c3b877e91c56661" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Adapted from bench.c in the liblzf source
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <string.h>
      #include <stdlib.h>
      #include "lzf.h"
      #define DSIZE 32768
      unsigned char data[DSIZE], data2[DSIZE*2], data3[DSIZE*2];
      int main()
      {
        unsigned int i, l, j;
        for (i = 0; i < DSIZE; ++i)
          data[i] = i + (rand() & 1);
        l = lzf_compress (data, DSIZE, data2, DSIZE*2);
        assert(l);
        j = lzf_decompress (data2, l, data3, DSIZE*2);
        assert (j == DSIZE);
        assert (!memcmp (data, data3, DSIZE));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llzf", "-o", "test"
    system "./test"
  end
end
