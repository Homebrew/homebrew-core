class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.4.tar.gz"
  sha256 "bcd223fac0e9b0e9dfa863aeff20c6fc1be2cc9bd27485199f0c92cddc462fb1"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a47894fb8d8c4cd9cc028d737f8e3f9eb74075a612106bd19e3f7bdc65c51b96"
    sha256 cellar: :any, big_sur:       "5f7043cc38c824ea25e5a6cd989c0cb17e68c2badecb2a766769b106048f6436"
    sha256 cellar: :any, catalina:      "708e892ce802a477a2696d94d0dbb377b4406feb578c9d1889aa514d7c630093"
    sha256 cellar: :any, mojave:        "8e239a05299933f52311c0715f5a85a811675a20566684c526c1f7fd031248dd"
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
