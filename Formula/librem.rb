class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a80a1dc2b30233cd4012de8b58ac9c7e87e17676e6026629d8b66d8a01600a83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa581ca442b8b64ae1346c9b25668eba65427522c2c7d3d0990e88c1f0d86eee"
    sha256 cellar: :any,                 arm64_big_sur:  "09462a747dbb8a0696971adb27ba80180941da7b2ff2ba47148233b1a18031fd"
    sha256 cellar: :any,                 monterey:       "18d9782748bdf9a746f67d53f2e444813b4066e0bd20a53d307318615e9930c6"
    sha256 cellar: :any,                 big_sur:        "8aa1ce18e745fd6d5a248991d5b4b79116b89f564090b1497aac02aa418d247c"
    sha256 cellar: :any,                 catalina:       "1c1283216defb2f25749a7e50f578f3a583ca459cbb500d03697fbe96549e69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b242355f18c8cd32598c86fa8986dc0df366348005e885453cbf84cbf62b9f59"
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
