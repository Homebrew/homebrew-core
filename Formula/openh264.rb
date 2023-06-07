class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v2.3.1.tar.gz"
  sha256 "453afa66dacb560bc5fd0468aabee90c483741571bca820a39a1c07f0362dc32"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af4d886c8a4a3df4fe67657099cc2ff74e6327890c71f678f32d7e49a321fef4"
    sha256 cellar: :any,                 arm64_monterey: "ae73e6d36f91ac47d93c4725356b6887ddd991d304af65015b958f4301fe61d8"
    sha256 cellar: :any,                 arm64_big_sur:  "c79e4b81dccaa0901dd4b0df153375479c430253b9a5e7081e5e48ae7c834e2e"
    sha256 cellar: :any,                 ventura:        "7c49620720886cb39b4a871783fa26fb194aa6b632b02ac15fe751baa98b1b64"
    sha256 cellar: :any,                 monterey:       "8a7b21814fc08e259a6fe8a9da00cac96d953ce10011b741dbd4feca426824ec"
    sha256 cellar: :any,                 big_sur:        "c0d6182c17eb670e2abe5ecc865b5c22119980f3940b00ffffabd78ff50e4d09"
    sha256 cellar: :any,                 catalina:       "a62c228494b27a45cccd967b45b741b726ef790a778c9e94e397e0cfaf2c320e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9cf3262fd11179defe88b448756d0c98f5f3a6b2bb0e2285ea843bbb694c106"
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
