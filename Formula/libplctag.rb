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
    sha256 cellar: :any,                 arm64_monterey: "5414308c8adcedca98dc53e69a1b634f4ce250f203bc7954aa4381e8f13fcd70"
    sha256 cellar: :any,                 arm64_big_sur:  "a469279ba15125f0cfba12eb46ca3b106297939705afcd0d3999f795a4f770b2"
    sha256 cellar: :any,                 monterey:       "3904730c530b458c9138f66be13d54a0acb27022571f5a9d27f79bf8916eba1c"
    sha256 cellar: :any,                 big_sur:        "50475836b92798ea6fdada91f2caf4899a9063120f720f535c3f4269fc9feb8d"
    sha256 cellar: :any,                 catalina:       "c10f3240d292aa3faa2031b03ff641f3c80f53aa0b8f38e1172f093f194a0d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18e8c739f2c8067966a051fe039464294d01fa6c54f1b5b9b3300c80da27cf8a"
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
