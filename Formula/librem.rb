class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "7f2b4e8db0fbf2d8dc593fb3037d4752aecf3bf50658c3762fe53494cd508cee"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bd7208a5a64cef0213aaabbfa80abb3f1d21543e5d2ddd7ac8e1deaaf6e13c4e"
    sha256 cellar: :any,                 arm64_big_sur:  "e642d360e5907bd4bdd59a1a252365e29fcda5c8c681f0a5fd553e806ca3a099"
    sha256 cellar: :any,                 monterey:       "9c8b1d984fe890ba9a74e87be7ddccedf2a847ff4f3bd79838ee0a5b6fb29de3"
    sha256 cellar: :any,                 big_sur:        "4738180948fa7172f39f952d9d4da82b96215be623995e5601b1953649e47d9d"
    sha256 cellar: :any,                 catalina:       "96c0cc1e895077c3c5919084a1d9c0dc74dc87f53b981575f6d4ec5209ce1382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64c4b1d20a8648aad62260e21597a30c434a1593bafcdd75e27bb6a3096a13cf"
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
