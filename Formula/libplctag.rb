class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.7.tar.gz"
  sha256 "49e6075680b5d8f37edd8e3ed66f9d827320f688b2a81158fa51105e5f4e8562"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ac406f24c68746e5bbd53487ee4f84c14317a45a73b19afee2cfd8c8599b380"
    sha256 cellar: :any,                 arm64_big_sur:  "276cd7c12e15d4152fd84ff15f62e532dac07ac3ec103344d0a4a232a5ccfab6"
    sha256 cellar: :any,                 monterey:       "4c392652a4624452ac4ad8c53f8b5eeada91ebdef9d3a531004b47c1c9fc6580"
    sha256 cellar: :any,                 big_sur:        "9cfffcb5d4b32da56caabfa5449c592fa52d999cdf091ec04d912719fa6e4d92"
    sha256 cellar: :any,                 catalina:       "b00dedf405499535cecff21b40c19dc3997a16301e6c201d63dddd08e638c85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9e38c3c7a8d304fc02c84bca9eb2fa0abae0bbb7ac568b7b7d938ca7b41b0c"
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
