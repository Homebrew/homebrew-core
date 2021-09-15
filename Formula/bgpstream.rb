class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://github.com/CAIDA/libbgpstream/releases/download/v2.2.0/libbgpstream-2.2.0.tar.gz"
  sha256 "db7926c099972468f1a2f98f1aea9a5a1760d1f744ff6966b79bbcc6651bdb69"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5c28bee02acc7bc557119b71bc714a9a505aa91ef58d2e390c6d7f75753d0f25"
    sha256 cellar: :any,                 big_sur:       "950968b0578b8d4131574c5fd985f56a1e10abd2d4aabdeeb408db2b323d6567"
    sha256 cellar: :any,                 catalina:      "a684f4249475c2c0531fda4467adbba15b8e07c4e49b8ffc0366cae16fc76888"
    sha256 cellar: :any,                 mojave:        "80262121246eb9431bedf0a64a12448ca1f2387caf17a8c1c7f20eaca6ca1069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7354b8e52ae543d5e48aa9a7f2c1725f95c7581e8006c02845da8fcd3b78c5"
  end

  depends_on "librdkafka"
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
