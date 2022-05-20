class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.0.tar.gz"
  sha256 "4a29097d7066769b059e0f3881ea23e68d7650ceb2aab2a6b278449823cba631"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c31efb51930f720724b7ad77d227f424ae2936c2b0dca50923156927c365e549"
    sha256 cellar: :any,                 arm64_big_sur:  "621930afaa9c98601f972a4c2fb53c630480052274265498db3a00c24e97b9ce"
    sha256 cellar: :any,                 monterey:       "dbcf0114a1018a12b2dcf12052a3329a3286e3b57866f5f5718eb4ca1de54929"
    sha256 cellar: :any,                 big_sur:        "d45aee3b6df573cdea2262682f5b28080d34f23e4fcb451b704d9c00f96a79bc"
    sha256 cellar: :any,                 catalina:       "dcd2ad5f5d68118f3a42452024eede2042590810d05233e4b05390c0a209c958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2912bbe05c51173ebf5c4e6abff445b8c6287e3499918e132159c0951faecf8"
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
