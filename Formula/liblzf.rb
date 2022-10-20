class Liblzf < Formula
  desc "Very small, very fast data compression library"
  homepage "http://oldhome.schmorp.de/marc/liblzf.html"
  url "http://dist.schmorp.de/liblzf/liblzf-3.6.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libl/liblzf/liblzf_3.6.orig.tar.gz"
  sha256 "9c5de01f7b9ccae40c3f619d26a7abec9986c06c36d260c179cedd04b89fb46a"

  livecheck do
    url "http://dist.schmorp.de/liblzf/"
    regex(/href=.*?liblzf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a929d667239b01aae65391c9bdb50b8979cf00746728274801dfcb69e7dba54b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e321946e647108f4f478e84270ef6a49463e18d412fc94a4bc260c5009bd2dba"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a3c8f9311082eb797c848798f98da622a9ec648669298090fa7ef5cdec6b52"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb80ac962ecb5b94ba1ed3dc86d2baa8a13f231d113a77428879e0a8423ebaf"
    sha256 cellar: :any_skip_relocation, catalina:       "9aa8a1495947fe1fd6249abe33de7245f9ae4a58dcf900276253b013f7f148e8"
    sha256 cellar: :any_skip_relocation, mojave:         "62c558b1b9562038c49c1e83b73dfb08d8fca8b924eb36428a5c0bb566408f9d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "66c9ec26bce56b59ffb317d5a415e6358e8246588a3f247c33b8a8d24e714570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04201793eebd3ab8a64694c1422e4d5801be13fd26d1ed257b6c31d4a231124c"
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
