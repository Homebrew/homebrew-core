class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v1.8.0.tar.gz"
  sha256 "08670017fd0bb36594f14197f60bebea27b895511251c7c64df6cd33fc667d34"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "d6034af9b67ecebd5be4e6a64d1c3f3c0438e7f5fff06819bc6f772c4a7943bd" => :mojave
    sha256 "2af5e6f5ef4dc7dcce2a420c7ed12ed06a252397ee0c24867a738c1b26ca73c5" => :high_sierra
    sha256 "a74aaa0c2ead93b8fbc31c6fd031be257188cd012583311541a2bc8b66dda4b2" => :sierra
    sha256 "ee2db0d05f6f3897fa6ece63a509ac1fffb8f33c7b02f8872af20e69b0e679b0" => :el_capitan
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
