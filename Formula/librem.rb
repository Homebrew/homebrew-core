class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "d25b7e7e109de141230a0f2d50c283687160c4f6878dc852d9ed0fcfc67ae369"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "699e3eab63cd9cf5866b49f5e8983fb5ac55780ddb5167ce2ca5dec5a04fa82f"
    sha256 cellar: :any,                 arm64_big_sur:  "b178354be3ffaa400644548e9129b6d0dbb1ef18f9f51a165420ea13b2c7527d"
    sha256 cellar: :any,                 monterey:       "a8836ec9dffaccca68e922a0cb0a704b2485f904ddc7f80328bd7547abe88cc0"
    sha256 cellar: :any,                 big_sur:        "53ef8d92e586a48a92f6f7497297be6c9257c50b390fa72d1c039d5b405593d9"
    sha256 cellar: :any,                 catalina:       "99aba430d95b96c6f1549e2b5ec177553681ddf629556d056faf5352040a46f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ab1e9df9f49c15c3f47db89d1415d96be6c65e8fd8ad6c85d75e97e5269784"
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
