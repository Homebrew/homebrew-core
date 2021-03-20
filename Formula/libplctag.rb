class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.6.tar.gz"
  sha256 "30151ac758a10e0a4be4ec0c65c7d9556f59b2b0d37271df68c0a26d4fdbed8e"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5125d70f46ef176f07e18d80303e53d5228b4a18330558d9de6da42ad4614403"
    sha256 cellar: :any, big_sur:       "fb1e16bfbcca8c203fe718460308cad4973b035db1e651b78ccc73ffda368df7"
    sha256 cellar: :any, catalina:      "6f3fb7f8b565597c16b46f5b8b0214c62709c3f4f5676393c810021fd566e03c"
    sha256 cellar: :any, mojave:        "47f2176425ba47bfaa760c1d8d55722b777c3e54643433f75448d6464ca34553"
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
