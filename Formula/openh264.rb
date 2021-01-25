class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.1.1.tar.gz"
  sha256 "af173e90fce65f80722fa894e1af0d6b07572292e76de7b65273df4c0a8be678"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "8025149092f1d95f870524cb04786fa08f3f67e1e60e259b675ba2a03b38949a" => :big_sur
    sha256 "548fde2cb583ccc88f96e931787b758c309100a6386cfd2bf9e4173cc1d99601" => :arm64_big_sur
    sha256 "40bbd156c791be70467bebecb927745edc9b54dd46aa2c4a317562a4cf1dce8e" => :catalina
    sha256 "952ae4b5cafae14722588046032ee363b7b027178aa30ec450e4ee916b85eb4b" => :mojave
    sha256 "de7a5593d7a401e606b44d88347e83651508538d2461e4510b024f41b8b0f42e" => :high_sierra
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
