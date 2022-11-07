class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.3.tar.gz"
  sha256 "4cffe1e5cd6bc3dc38f49b445f43c72d55c33d005fbf41d2a54ce669ebfa7d3e"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec6a8b12f893be35b4d78732111d1cd80f123a997f87af34f72695fd771c1710"
    sha256 cellar: :any,                 arm64_monterey: "c585464cabedaedd29a7d771226ab494eb97f308328db58f5c2e60e63ce739cc"
    sha256 cellar: :any,                 arm64_big_sur:  "077c8787cfd4640849bb38986b2cd4cb02fed076f0cb4973f539710395d2184b"
    sha256 cellar: :any,                 monterey:       "cbbaa291aa05156c4af913cb2ad4c88ce0d4bccd86603773c86a6c4a25bf443f"
    sha256 cellar: :any,                 big_sur:        "37e9b6c5dbf7de778d1047acceb6d8bf7f9ea51451d5ebd041aa128afdfaa115"
    sha256 cellar: :any,                 catalina:       "df5fb5af81d4c53c53d5afef71046ff13e6b5f85088291e51941b132e5aee357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c76c0b523ecd0033b62183eb8672cf1509ea81d75563d3e1bf51feb6d7f2784"
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
