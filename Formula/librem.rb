class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.5.2.tar.gz"
  sha256 "fbc54e81ed4fd28a11d525f4384d06bee4c11e10975395668e8260ef0d4a64eb"

  bottle do
    cellar :any
    sha256 "d7ded43ee81a52ebd7c845938ad7190bf91b7efaf4a547cbfd929af965a9dd81" => :high_sierra
    sha256 "cdca7bd06d6fd9fd0eaa45db2dd5fd523ee1280ffb7d6f8fdd545839221a1688" => :sierra
    sha256 "ffbb2918eeaecda2dc46722a77d7a03344ffe9e8c2be921c5d373f1463c407cf" => :el_capitan
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
    (testpath/"test.c").write <<~EOS
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
