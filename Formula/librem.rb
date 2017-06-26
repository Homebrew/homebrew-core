class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.5.1.tar.gz"
  sha256 "6c35b6cba46d9bc25fe018a6c77361e4c6421794624f545796323f75d6b38eeb"

  bottle do
    cellar :any
    sha256 "3dc7d7827e0be3545a675a54f78d2baf812dfe5c45a8068de7de2a39daf8c44e" => :sierra
    sha256 "7ca8c91179b72228b42b28adf9cc63d90169f199e657ea8275646c71224fd4ef" => :el_capitan
    sha256 "45cf36acfb57d518a9c1a9da4a2c63a57371d7be90f1343f6cb2d61691afa6da" => :yosemite
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
