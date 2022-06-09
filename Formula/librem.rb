class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e9c4ebb63fe37dcf77638f280e619776d4e93884d9063084432f18bff2020cfe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "adc166347b0d36bb87261367d7272b34f82e3d005963e7612fb5c01189cd2991"
    sha256 cellar: :any,                 arm64_big_sur:  "5308edf36b5c93b02b438aea5b72cb1ffc763ed1fc0acc7d822f39bcb7ed08cf"
    sha256 cellar: :any,                 monterey:       "875583f6011e284b28e136befc619592a05053fd5c622e58993fb1f476d2dd55"
    sha256 cellar: :any,                 big_sur:        "3c9082aabf1909f264b6282018ec952ce7f388c1f026a504dd05235a71a99f95"
    sha256 cellar: :any,                 catalina:       "a247fb6d0ae5458ee589f564e20b41604068d78730b815cfb3946d5412edd316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488f6d7dd6869b3d102c0ddbcd336c6675aa27128ecb906bbe56709dcee8ae7f"
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
      #include <stdint.h>
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
