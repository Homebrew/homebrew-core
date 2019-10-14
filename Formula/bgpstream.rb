class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-1.2.3.tar.gz"
  sha256 "2c1affec8d38a9f750029e48b77a46064937d3e41f6c10dfac72777fa934cd74"

  bottle do
    cellar :any
    sha256 "26f6a06267aa23f01fa2b625b1d5ae61d54a9f792707227892c38e30999bb456" => :catalina
    sha256 "23ffe0dcc9ba7fbc1b497b955b81a6515d269f93be06356dd00e531ac8d8d96d" => :mojave
    sha256 "8110166953d43112cd014092d0dc58005ceae09983156b73dd7ec7ada7af33af" => :high_sierra
    sha256 "d1541897010832dee6be24eb2e37ebe59899653f2277da1b34d29c6953754b6e" => :sierra
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
