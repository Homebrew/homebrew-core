class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "aa1729c170804667ef4542693cada38608377c8bc257a5f0171e6d4015d6870d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5a38e3365fdf3dedb5d3ad21f54f8b87d27f0e09e23d4a8c7823db1f6b729b6"
    sha256 cellar: :any,                 arm64_big_sur:  "72448852975c6c82701534b5349d500e7fbdaaf172eab9262152caffad5e47fb"
    sha256 cellar: :any,                 monterey:       "232db148012903d2febc3e3552dd1708c7aa817b36cba0edde7b424694744889"
    sha256 cellar: :any,                 big_sur:        "0648429489ac82d785473873ef86b8ad691beef0d8dc9ac7edd8c06f47a2573b"
    sha256 cellar: :any,                 catalina:       "e13457ee6400eb09e1cd345543462ac1dee5217d0f08dc65331eacf07df4870b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fdfd97688a0fce69a08b0f03f5e78a3fda9dff7c2a25c8613c16ed7e1676214"
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
