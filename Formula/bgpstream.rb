class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https://bgpstream.caida.org/"
  url "https://github.com/CAIDA/libbgpstream/releases/download/v2.1.0/libbgpstream-2.1.0.tar.gz"
  sha256 "27a84f8048c885f67353a1fc9ef020aa8453621a15af3ae706a1fc8e776da80b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d94daceac3ccf6fc4a59d532dfb1a4205b49002bebb7052e9488057d09c53d81"
    sha256 cellar: :any, big_sur:       "2ef31b4b6155966b7ebb5bea8fef499e5a75e40bb0b4cc827387c20e1710908c"
    sha256 cellar: :any, catalina:      "4879ed386a49e62ff13e465d822f0d6b6ea126cd7ef95add1fc8b4c0bfeb2dc6"
    sha256 cellar: :any, mojave:        "ed2c647b81542296080d2235d292598c9b654e4cd7a310024ea6758e2cb41aa4"
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
