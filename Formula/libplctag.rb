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
    sha256 "0664ba0ed1f5477ef2b5967bc98ddf3936911d9a83d782f3928cb98cfc5e8494" => :big_sur
    sha256 "40ffae5a14dcc47d0af848d74f5f070c96c32b918966b8312407c8ad36d6152a" => :arm64_big_sur
    sha256 "8c1072c0150e40bf21a646ba6417dd84585775f2f91a99340d7618d0c96bb76f" => :catalina
    sha256 "bf0b9fd95a793393d4ab6c6bacc3398b073b1c62bc80702efe71910bf73584fd" => :mojave
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
