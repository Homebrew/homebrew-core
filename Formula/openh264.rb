class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.6.0.tar.gz"
  sha256 "65d307bf312543ad6e98ec02abb7c27d8fd2c9740fd069d7249844612674a2c7"
  revision 1

  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "903bf2b9e0404082ff0d07e0647be4cbb06522fb8ca03e106333013629d8a2e7" => :sierra
    sha256 "3643187b745aaaf1ddf568ea2b1f89c3bedd32623958f65136c48def0ab01707" => :el_capitan
    sha256 "34aea9729427b13ce07e86de2e5163ddef33db8fc4e96ec181d726312e32e977" => :yosemite
    sha256 "b7bb8df9a884286502451298496266ad0f8a4efe3aac57c859c615365406a3b1" => :mavericks
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
