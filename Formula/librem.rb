class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "7f4ad245eb9fb07a82890022d1c721c93ee2e299acb88a7e775ca541f7a09892"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e5f8a521da904deffef99314ed36c6c43888a999dfbf465c52dee9cb05452ef6"
    sha256 cellar: :any,                 arm64_big_sur:  "2200670c86080f78d23c1adb9b1f2229c91dcc94f0f309a7594eaf7304c5d45b"
    sha256 cellar: :any,                 monterey:       "1454c2f9eba38d761f4f99e45d766bdd30507f6a59a68ba095dc516ff5545e0f"
    sha256 cellar: :any,                 big_sur:        "4c097ba26f1374bb892d5134661042d8518a57a4b59ec87b5a8328311aaaf7e7"
    sha256 cellar: :any,                 catalina:       "ec13bba6c8d857c5f06cca994ce4048c97589ebe8943bb1d1f40605199a3c1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176e84e3c75d0c4c723f1ea8d980d8694ef18933073142e4b40cba593ec5082a"
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
