class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.3.0.tar.gz"
  sha256 "99b0695272bee73a3b3a5fcb1afef462c11a142d1dc35a2c61fef5a4b7d60bc0"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "850c61c729ea016b0994f7179174bd7ba25d360afb99b0f432af161c2aa0409f"
    sha256 cellar: :any,                 arm64_big_sur:  "9d5a2df60da72b153ebcb7312930e710a7e7ad10d9e4612947d09a9f375bd6ed"
    sha256 cellar: :any,                 monterey:       "8ce4c3f088316d948efe32844e848cf04744479accc782c61f52a0fb40bb9843"
    sha256 cellar: :any,                 big_sur:        "74096fa190b838ecbb8cd5467b0e1787b89b76f5c71497e8451191b5a5a1a64b"
    sha256 cellar: :any,                 catalina:       "0063b3813acce3b6e95d8bb68d12c05c097459c8baaa8ca2d951deb2078e04bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "714856c2805e22cf067855c815060fa098e62bc96571e185459659a7b35d4c07"
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
