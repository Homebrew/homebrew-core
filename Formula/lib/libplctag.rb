class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "d46b8240d75a34d8c6bf9f840a3500dea68a9c7c7bc1d8d48857953c2d4814d4"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bf9faa4c26ec6e22569fc87cb0755798b65fbd0352b9678fe09c8d06f4c2684b"
    sha256 cellar: :any,                 arm64_ventura:  "7bb10e1819e7307d8ee3ee3d05dd7fcd156016c55aaec12317f01665a3aa136d"
    sha256 cellar: :any,                 arm64_monterey: "87b7bfd60e4387037591ef9954d6955a61c8043be05186e5265963460c848baf"
    sha256 cellar: :any,                 sonoma:         "d389b9bd61beeef4a9a38271a9571e53570356c778130a858967142e6249a5ed"
    sha256 cellar: :any,                 ventura:        "94eaaba1b6bf9829a97b5ac8bc51b1b30f957b83069bef72e13f1a9a8b88bbb5"
    sha256 cellar: :any,                 monterey:       "f7c8f4c99c014a84cc9e6e5f1b3697d622ef7185225849f59eb366215edf459d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d0e6263313ddc9d2a8f4ad79e19514994396e9e8eba8eeb09dddae51524d1fa"
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
