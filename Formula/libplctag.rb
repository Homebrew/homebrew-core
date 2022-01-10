class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.10.tar.gz"
  sha256 "c1edd48c156df040c834310461e9d40c2fbbd810704d12cb660bf3f9feb259a4"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e112b125c5afeb6af765d13677b6a057f0faefdb1f902766c8467b1e28db8a14"
    sha256 cellar: :any,                 arm64_big_sur:  "5a388005d07c1845a1b34838980fa131b9446394d9751e3addbbf1a615976650"
    sha256 cellar: :any,                 monterey:       "24fcedc8180bb0529eb8bcd5a87eec543f2499e9984b235bea14323d8b0ce09d"
    sha256 cellar: :any,                 big_sur:        "1a7e46f3623a7fc42f43177d595f52a034d5da7d35b826c6ae6717eec1c4bd5e"
    sha256 cellar: :any,                 catalina:       "48935d2f8d32bb884c1b18ed1296bedaf3c73a3b734a8b945988cfe3ab27cde1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3f67a7d9f1eaab3d237295852acf68b8e8b7f0317b0d05b2724e8f8bedd776"
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
