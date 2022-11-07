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
    sha256 cellar: :any,                 arm64_ventura:  "2be0ff9826fe5a923b3558c7f6ee06b59932dbab52de46fb3eb8d0e37403713f"
    sha256 cellar: :any,                 arm64_monterey: "f2cc6b207c03cd58fdbaa5b07e4ae9d15474bf790bae943befc677f802db583a"
    sha256 cellar: :any,                 arm64_big_sur:  "9e597421cf3135aaf95cb870896cc1352291d65f0044b68f7bbf191ad0422eaa"
    sha256 cellar: :any,                 monterey:       "3e16f4bffdf9119f071fac7d1bbfd958604ba002977677250e243ebd10400e01"
    sha256 cellar: :any,                 big_sur:        "361d9ab8bb0125b209bd5360387bfac2916cfe6c5b71e1bcf143309e692628d2"
    sha256 cellar: :any,                 catalina:       "22c0f1fa593c3c6bfbf7720bdc6d2486f6ce93e99696a415702c8bccf8f2d454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "228aebe5ac76a6bf3b312d8a57a6436f6fbdd5c586aab602e2d974786937ee14"
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
