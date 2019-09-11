class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.0.0.tar.gz"
  sha256 "73c35f80cc487560d11ecabb6d31ad828bd2f59d412f9cd726cc26bfaf4561fd"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    sha256 "0a110d3d44c184d8019f5442296a005d5d9d2415c11df117a6a8e526f514039f" => :mojave
    sha256 "dc02b0c4aa5f4b777e982e71ab244e583de8dc811b99c342806325ef87ee533a" => :high_sierra
    sha256 "95b82a01da74048615c89b8d99598536d84f3704edcd132d70fca60c2900b572" => :sierra
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
