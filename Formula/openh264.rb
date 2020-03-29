class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.1.0.tar.gz"
  sha256 "27f185d478066bad0c8837f4554cd8d69cca1d55d5f3dc6a43a8cef1fe6c005f"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "b8aa9f0ebd8396177e501d5b792b29b335cf3ee08e314de2a373c5bd67b37268" => :catalina
    sha256 "f1d5931a104f30c0dc9b36201a3997e8fdca2bddb70cba90e6ddd83ba4fcd8e9" => :mojave
    sha256 "2eb6051056e35bba0b2e0c36cedc671605d5c1e05c87164dd6a971b01e95f674" => :high_sierra
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
