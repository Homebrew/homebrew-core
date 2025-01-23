class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "ebbcd659d5137d1299780e49b139d1e991b5a731df6dca0d7130b58555673a6d"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "531813b0902a9c6cee6547b724bd790dcc25bdd56ed8c4d83aa77b0ece77df95"
    sha256 cellar: :any,                 arm64_sonoma:   "dc6b380ddabd0deb6356e5c4858539d5d93c467521127541c1178c60fdce213c"
    sha256 cellar: :any,                 arm64_ventura:  "f05b40f9a1a1e7ce4836a9aafefccb0f0637293457b50af1011138df5115b72b"
    sha256 cellar: :any,                 arm64_monterey: "8ee7a04c8066496aa7519a12acfca94b4e49d18fddfeb4b39722277146516ab0"
    sha256 cellar: :any,                 sonoma:         "56c790736952cfeec473004b11a6e802a64632fbe0b6310137e24fd6ea27e034"
    sha256 cellar: :any,                 ventura:        "c2f745ee79bbf95b4c48a80942954618c77a429ffeb9fb8525165f3ab8682d30"
    sha256 cellar: :any,                 monterey:       "b6a35d8303c4198bc22f38a4f60ad6aba6cf4ec5593cd77eaa207dbb2779a13d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fceb54a005681b6071a970c62cf2e0ce0e2f1719bca67aaf34d648f22349a510"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
