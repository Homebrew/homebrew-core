class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.8.tar.gz"
  sha256 "440d8786d50c7cd8d90a40e1431e38e079757d67a4f658f3895a2aaacd5cc26b"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cba1c97b2ef7672526345d3185c5ba012015f063be710a12ec2f57add022434b"
    sha256 cellar: :any,                 arm64_big_sur:  "9240709f2e2b5bdc78ba4241c74aa01a2eb910028b5cf2f6152a0faba16367ee"
    sha256 cellar: :any,                 monterey:       "8a6a4acfdce2432d097251a5937a0430855893342c48604fe0d145ce5aaea8f6"
    sha256 cellar: :any,                 big_sur:        "5f9db3022156243dd9a24d1ef2f8927ba7ee8ed2b8df2989f1a7ace4b958f6f9"
    sha256 cellar: :any,                 catalina:       "2603157268370b115fdf7dbb5b1f54163685723f29372bee55e6133c1eaab0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e137249891c24f0a350b3adddb8d643b15e98e4a6faf8fa50d7a2cf6c4c1d17"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
