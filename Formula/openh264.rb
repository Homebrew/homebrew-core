class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.2.0.tar.gz"
  sha256 "e4e5c8ba48e64ba6ce61e8b6e2b76b2d870c74c270147649082feabb40f25905"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac418886ca549ee2314ceac303e2a75f14128bbf50a364bf3fa897e6990e74ba"
    sha256 cellar: :any,                 arm64_big_sur:  "516ad67a9e9ec7514f640734411a5d02e5b01f59ba39ab29aad0323d6e9d0fff"
    sha256 cellar: :any,                 monterey:       "add5458dedf101bad97882556a748ae65026698733eca39770aa10efa16d7818"
    sha256 cellar: :any,                 big_sur:        "c53a7e8bca47d027408277325edefef2355443bc302f61f1c7583189d6275231"
    sha256 cellar: :any,                 catalina:       "79e8f9ae3259899d18839e8796d36ffb1baf453952d5516a304eba69b81c3bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d873035084f800e380a82b7d66055704d0fbd9511e912227f2b0d8e18089070a"
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
