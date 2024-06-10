class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "466ff698f0ea854fb83eaaab420251b4fb2ac6e226fe1653831b627b1a41fa10"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6e4ffa92175057a5cfd13cbbf07fca08ed6bea042c255f922262ceaf9c08714"
    sha256 cellar: :any,                 arm64_ventura:  "e80aef0db27648117dc082c8944af6f441a6ffecbb97a3e0a153e4db9cc0289c"
    sha256 cellar: :any,                 arm64_monterey: "4b5195eb0184fe044954a142c446a1eebc0ae192de41821c42dac407a089af45"
    sha256 cellar: :any,                 sonoma:         "e3e70a8ee8ddf40876ef121f47b5fd24c81e4c47c133c5e9b2400657cb423a53"
    sha256 cellar: :any,                 ventura:        "196e323d12bfc734d0277f97ddd9cabc876219af75d0a36fe7b1ca18009d0bc3"
    sha256 cellar: :any,                 monterey:       "60c5083210a524e3727dae710b2b5e112c6e6a7343e9812d39d886028f54793e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5af60ecf3c330ef7b8fc61f1d572e44b2c43b39dbdde49c8a022d1d24733f69"
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
