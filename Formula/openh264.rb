class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.6.0.tar.gz"
  sha256 "951109b86cf82be7d2aa65e7542edf4bdf26ae9ec93674c638d28c02a9d1a59a"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "892cfb1439d56da36c281796f6688e3a0fe17f5366ad63cebf4b97cdff2d6d9f" => :el_capitan
    sha256 "6cbd5343b41537de8bc801df2c4e086d2799468cfedee730d5de20b5889877f4" => :yosemite
    sha256 "941eb918233c28b8b87f9df6f6480f66c276f4296e429f383300ed4042612517" => :mavericks
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
    chmod 0444, "#{lib}/libopenh264.dylib"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lopenh264", "-o", "test"
    system "./test"
  end
end
