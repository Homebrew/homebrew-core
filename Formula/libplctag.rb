class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.4.tar.gz"
  sha256 "9c1a9d55cb686846cbe18aac736284f6f904c2817dca89126e2c692916c6960f"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a336be033c176ecd2c0e4ae71df7b3b0e08a31c4887d74edd3a6e2eccfcc8e8b"
    sha256 cellar: :any,                 arm64_big_sur:  "65634a795aff5115dc69265df95ac555d25d00e007975a8d3f4e84897893bb72"
    sha256 cellar: :any,                 monterey:       "2a06eb9dbe5bdfcd0b6e7d17d6569ac32f3e4d88133db0bc996ecff92a5494cb"
    sha256 cellar: :any,                 big_sur:        "125c7fae46054ecae3ec63869abd81f9d9dcb9ad8c9bacd727beadc84d65d8aa"
    sha256 cellar: :any,                 catalina:       "fa34281919389ec607c1b64ccbeac21ab944c156ec11f07a13b830e927344373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb433d811630018e1d45ad106534e98fc431072467518ac22344fa340acf5ca"
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
