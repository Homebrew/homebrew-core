class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.5.5.tar.gz"
  sha256 "ff9aee851c75fca28dc8a1e500d456d48fe34ba7046860a951be9d47a2e2afa2"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f314c6bec2fe4c10d80483910a75697a19c1d8d507c561a7cef142d60d37307"
    sha256 cellar: :any,                 arm64_monterey: "2707bcb0107d98c58b55c48f7556548a05c13a7d2ae957169adea3e30235a6c5"
    sha256 cellar: :any,                 arm64_big_sur:  "35a25b3091610777dcf8bddfa7231e480e7d0afca7cdf687173d629161e9d10d"
    sha256 cellar: :any,                 ventura:        "18321eeac311fadf1be971c5f2fe64e55fa325e48e40e086367448f90694a738"
    sha256 cellar: :any,                 monterey:       "653d01bb7ffda8da6d27e7f08cc4cffee7121c033ec7a95613d97abed4daf256"
    sha256 cellar: :any,                 big_sur:        "cfe95a0eae93dd227463c7e92fe68d337cfb97c5488c709854a9be6210921c29"
    sha256 cellar: :any,                 catalina:       "370f105c64aa84fc2deff75ea5c2c3dde80850592c089246c08e4a344853b48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51b508b126af0134571fe3b4db20117c4f414527977e1dc553c2c881bb2c109"
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
