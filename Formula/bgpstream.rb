class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-1.2.3.tar.gz"
  sha256 "2c1affec8d38a9f750029e48b77a46064937d3e41f6c10dfac72777fa934cd74"

  bottle do
    cellar :any
    sha256 "e0ac7face3c4dbfd5706d1d1ce34bf232ba824ebb96320b3395df6eb4c7c2f71" => :mojave
    sha256 "d8dd9378b5035d3a3e36f0fed7af1716beb1f884a9e15e687c1727ab8628d69a" => :high_sierra
    sha256 "48f399b0a4ecd94296082fa0cfb4ab74f71f50c236509c87aaefae8fa55173b1" => :sierra
  end

  depends_on "wandio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "bgpstream.h"
      int main()
      {
        bgpstream_t *bs = bs = bgpstream_create();
        if(!bs) {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbgpstream", "-o", "test"
    system "./test"
  end
end
