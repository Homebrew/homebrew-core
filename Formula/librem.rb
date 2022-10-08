class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "7f2b4e8db0fbf2d8dc593fb3037d4752aecf3bf50658c3762fe53494cd508cee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c6902c502a33f9a9bacc022bfe081bc50e8922896b57aa9bd81c091136a4066"
    sha256 cellar: :any,                 arm64_big_sur:  "e8a6c3bdcc439b49c07f4603b2ee16f1de0f864c2f51344ffafdedfe17753703"
    sha256 cellar: :any,                 monterey:       "de771bea5ab62f1ced16d90c47a1549aa7491ffd053107b8b77968ecb568f452"
    sha256 cellar: :any,                 big_sur:        "afbd8866f9bcdd51231c6972cc0693aa2418ea15874797ea9211be94a27528de"
    sha256 cellar: :any,                 catalina:       "9188c351610c147aac6af685f1c92daa2506bc115a74280b05693d5f10a6cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443de5d51a38df0f387e5c6db80ed4533026e9742a5bf6e927f1f1676c3c8742"
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
