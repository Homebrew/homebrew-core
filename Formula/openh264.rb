class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v1.8.0.tar.gz"
  sha256 "08670017fd0bb36594f14197f60bebea27b895511251c7c64df6cd33fc667d34"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "140ea346ab069463ad1c4c588d12636413d4459a0f5c30a891b1cec7273cdf06" => :high_sierra
    sha256 "d3daaa5995cb2ad25fb3a4e0a9e99de2c4ca5c98f3da4f455b5e58d04aa3e6b2" => :sierra
    sha256 "1b9c6a03cd9dfe776d1de7c23e1b210f25bbeb1b99e4a12d1f4b8a354498a3ab" => :el_capitan
    sha256 "28303efdce99fbcc37ee2045398ea060170e6690936acfb8c2f4bb1378dac079" => :yosemite
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
    chmod 0444, "#{lib}/libopenh264.dylib"
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
