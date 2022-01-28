class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.2.0.tar.gz"
  sha256 "e4e5c8ba48e64ba6ce61e8b6e2b76b2d870c74c270147649082feabb40f25905"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e31c4b9305a7f4d535c7fd05b14b6c6e6f0b2590fe855ff4be5936092e92c0a4"
    sha256 cellar: :any,                 arm64_big_sur:  "c63f32513ab056a1848184f11c0d82b1c233d81be4a9dd9f29df89029be9ea75"
    sha256 cellar: :any,                 monterey:       "6cb69daec8b18057e91cfa4d2c050b3ffcc497069a034e1a16334a01f05bd0da"
    sha256 cellar: :any,                 big_sur:        "b1679e30909ec05ca67b2f134a8e322319f845530005c185bb7284c2b2fd1301"
    sha256 cellar: :any,                 catalina:       "0c16ce9eb6bc29bddf43376bc6ceff0ab6843572edb3fb631dfc9e135d7a3208"
    sha256 cellar: :any,                 mojave:         "f42bf16f4d86c24a6562530db55ffb5957a83b26443735bc902f5856b3470cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07f021b1018f609937aefeb4c311c46545b7ba5009f7cc75155add033089f08"
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end
