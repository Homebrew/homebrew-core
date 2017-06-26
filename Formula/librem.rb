class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.5.1.tar.gz"
  sha256 "6c35b6cba46d9bc25fe018a6c77361e4c6421794624f545796323f75d6b38eeb"

  bottle do
    cellar :any
    sha256 "d3ae13b97276ec22412989e517b2ce10f8649088444b485016108952591b30b3" => :sierra
    sha256 "ef42e569ec7be8cbf83d49f858e9657b493f76380afc00ce49ad9bc5ed5c912d" => :el_capitan
    sha256 "4ceca1440d4432e89c9f1150b8e68ee7343546eda4d6cd2aa6b06abffe8afddf" => :yosemite
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
