class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "be2ab427cbf34f5294ce5d831947352e54d5196401fe9c232722cc41257a91e1"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f764ed2cbd66f566fe541a5055c869b04a059d6e6a4f6c65f1b208e0ff990bea"
    sha256 cellar: :any,                 arm64_sonoma:  "bb8d208ccc467ef2d3c3376aedd2b02ae29c5f903f93ee89bb8f58e0667c5261"
    sha256 cellar: :any,                 arm64_ventura: "5db3e3c20011d982ec2ede30c77868ff64c798dea2e4e898eaac366b17a878b2"
    sha256 cellar: :any,                 sonoma:        "1f24c8278b66eb8acedcc91cb793f7ba201ed36bbe3773eb6ad542fde72d5bfc"
    sha256 cellar: :any,                 ventura:       "9413853ab4a7c1c8190d6fc4535c86c63fd8a89cdd6ada1f118094bfced29c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe5961688b5fb94c867081b35a5f14e5d952a74560fa2cf9919388c12430fa25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4da071b6a200ad009a70fb3560ea98f1885725ce465c57475f76147d1e4be7c"
  end

  depends_on "cmake" => :build

  def install
    # Fix to install libraries and .pc file
    # Issue ref: https://github.com/libplctag/libplctag/issues/526
    inreplace "src/libplctag/CMakeLists.txt" do |s|
      s.gsub!("# install(", "install(")
      s.gsub!("if(EXISTS \"${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libplctag.pc\")", "if(TRUE)")
    end
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
