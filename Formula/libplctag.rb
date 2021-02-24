class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.4.tar.gz"
  sha256 "bcd223fac0e9b0e9dfa863aeff20c6fc1be2cc9bd27485199f0c92cddc462fb1"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1c59cfbd7f3cbc7ddc8ec5381665cf80bf39b23b15df9e07bee4b086d8cd03b9"
    sha256 cellar: :any, big_sur:       "b0be2c3be678c3d01b504b4d541e27bf7ac515496922857f5b88d4182c75297f"
    sha256 cellar: :any, catalina:      "1abd8251ffe63d6f2644390309d50f0f7598ea9695498dbeb1a2b5510602fc07"
    sha256 cellar: :any, mojave:        "ebfac65607a0794d63c877b7cd99469b7e23920e2f253ffdccf988316c1eba5e"
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
