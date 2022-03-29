class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "aa1729c170804667ef4542693cada38608377c8bc257a5f0171e6d4015d6870d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "632e4be4c8fb4a2706d926f10f1bdea97d216727c267edcaa06243df413d4479"
    sha256 cellar: :any,                 arm64_big_sur:  "b1ed3438f5f9df958dce188f3ca00c7ae2c74171c96b221e4c744341be0a4102"
    sha256 cellar: :any,                 monterey:       "b11acf9f97f836314277d3a8b19df66a4586ada58f45253e1c942d300696c604"
    sha256 cellar: :any,                 big_sur:        "7a9f6baf6d099b4b2e044fa145d7bdceb185ee2b5f7f4cb35d4f9d266baa3e8c"
    sha256 cellar: :any,                 catalina:       "31935ce4ff60c59a1c49c7f1c8b102258b48f3fbd0c4334a1b9b069380560efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4278d958c1bd5ce1d8204610d742d53ea2a4cbd391d7ed1fe21d27574c55abeb"
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
