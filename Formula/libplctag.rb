class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.2.0.tar.gz"
  sha256 "ba0ca955fd92ff1373d353d3112441e5436a6024c2d712f39e4b47c008d2d1c7"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "4ae1e19a43a22ceae58258052580171199f5d8d410e0dc2a2f3e6fc2af4e1e0b" => :big_sur
    sha256 "23131f240da580b83beb29c6f7862d6f829ee994d83121918905eea3033467ad" => :arm64_big_sur
    sha256 "d24ac6daf5f21ee971aa04a9240ebd9cb75147c9cab4081f23f261f5923037ad" => :catalina
    sha256 "41ebd02e8ef20058db1950e6c69523f4e02a38a439c9b96d802a34376c4ec0dd" => :mojave
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
