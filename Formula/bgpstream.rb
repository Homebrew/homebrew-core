class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://bgpstream.caida.org/bundles/caidabgpstreamwebhomepage/dists/bgpstream-1.1.0.tar.gz"
  sha256 "b89cef45bcc5ae4011aa3c42f689ae9fd7b5c8fd25e06ab18589577b5e077f89"
  revision 1

  bottle do
    cellar :any
    sha256 "5de3479fc0a9c0d4e97c852584ac29f0b0df86302dba981c1120a6b94bdbe58b" => :mojave
    sha256 "f6db5e754c3c44b70aa1f2af5436fce55ec8046d70d51fcce8f6f2f7e4bfa4a8" => :high_sierra
    sha256 "56f712d3a9f3540b0056c9496c9a038b195eddcde7656cf8599d3a450858f12f" => :sierra
    sha256 "28b012b8368630b46e02d0d94c9099e06db88022f02ce0bee6596fdd21755649" => :el_capitan
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
