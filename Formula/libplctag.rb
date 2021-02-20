class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.2.tar.gz"
  sha256 "b282118f8dcee692af2b38e1d14aa58e12ce90ce30606000b5318702f7d19971"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fe18e2cb621558999439032208d2633ace7a8c107a592612b3c54fb36449c79b"
    sha256 cellar: :any, big_sur:       "6383770e8a2142674fd4ac5bf7eda1efe15989f158ed4ad02f36e2bc19f26458"
    sha256 cellar: :any, catalina:      "540cab0c9819114eb965b821946069872875d4b7399cde095996ef18b7ebc8aa"
    sha256 cellar: :any, mojave:        "73fd6ce4ecb3ab6d5cad76d204a7c3c9268ac13c72297721806053b7bd47a4c0"
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
