class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "2c734305d1a2dba2b270ad4b7f780b1b68dbfcadf3d21ccef834b3e8b5289eac"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "953fe36579a3aa5720f61ef25ddb8e8ee0b5cd919431b8d3a8e8e17a31c0a0c9"
    sha256 cellar: :any,                 arm64_sequoia: "67dc4be3995bfbf1a214bd9397a2b529c85a7a59a8a283aac44ed6e831b8f5da"
    sha256 cellar: :any,                 arm64_sonoma:  "43bda34f7e861618962084f0bd0622e9655d2e1d3352b6dfc681102bc58a6a58"
    sha256 cellar: :any,                 sonoma:        "09203ef37f37e9405d04c0f6049fd4f8a6d05511fa19c2c7e232b4c74e34408f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84a9135ab80f07ca1cb450565d713495bb64eb4904feefd5481caefff34a2c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4567170fa0f438bce0083baa89f1f00a50293137fe87214c45d348eb68b37cba"
  end

  depends_on "cmake" => :build

  # Backport "ab_server: scope CIP_SRV_UNCONNECTED_SEND case body", upstream pr ref, https://github.com/libplctag/libplctag/pull/618
  patch do
    url "https://github.com/chenrui333/libplctag/commit/b19081bc35bd93893b343091add7d638ee3fe532.patch?full_index=1"
    sha256 "7b84abb42b4ba7b72b2b391f471acc56719481b590634cd1afd0576e7d1e1432"
  end

  def install
    # Vendored libyafl uses MAP_ANONYMOUS which requires _GNU_SOURCE on Linux
    ENV.append "CFLAGS", "-D_GNU_SOURCE" if OS.linux?
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
