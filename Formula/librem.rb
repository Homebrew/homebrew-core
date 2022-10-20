class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "7f2b4e8db0fbf2d8dc593fb3037d4752aecf3bf50658c3762fe53494cd508cee"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a9021534292e4ff43c5aaf0e60f7c6a865ac1c66804715270eeb9b00591fb7e4"
    sha256 cellar: :any,                 arm64_big_sur:  "0e6eb849ea3fd48c5518504e081a362fa12ed840daf2efc8e01b411f42e47b2a"
    sha256 cellar: :any,                 monterey:       "ae085d19b0a5e5cfd8213c6a9bedb29c6f2d6d04908b6fb53c18e60372316d7e"
    sha256 cellar: :any,                 big_sur:        "dfec71bd9afec828fb575fda158f253f4463cafc3ad6713de6e009a71b45230d"
    sha256 cellar: :any,                 catalina:       "61cddf830cccc4017bc8f6eda5c8e2e86aba0e97fa17c8b324639f1494fc8aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63af19c3290e075af5daa0af489df283fb3107a7df20ba6f5aad5b91a00ce64"
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
