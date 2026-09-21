class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "09057d893a418e10c977267fe57a0195a4b8a4d7e512acc2d9ccef0314823056"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b520aef7d1da7c69b0422c5af054d599009d0535734187a7aa73d15d55a3b732"
    sha256 cellar: :any, arm64_tahoe:       "5565d31440ae59118983632ac8e0124dbd36246629d49becc4000334155894d3"
    sha256 cellar: :any, arm64_sequoia:     "1d6cbb299e76c1dd24bb07a7731440fef65774c830ed27c70af9c5f48c797fdc"
    sha256 cellar: :any, arm64_sonoma:      "3837c9a5047966c422dd421f5f774ad9771faed03fa9a51aff5025854cd3abf2"
    sha256 cellar: :any, arm64_linux:       "faecea38c611a8d6a34d1a2775015ff3d9d8e793c95f9de8e6c12fc4b31f2dd7"
    sha256 cellar: :any, x86_64_linux:      "3ab1018bf79facc3cf65e62cd6dfaf5a8195fa3e1928908eb5f0f670abb81a62"
  end

  depends_on "cmake" => :build

  # Backport "ab_server: scope CIP_SRV_UNCONNECTED_SEND case body"
  patch do
    url "https://github.com/libplctag/libplctag/commit/b19081bc35bd93893b343091add7d638ee3fe532.patch?full_index=1"
    sha256 "7b84abb42b4ba7b72b2b391f471acc56719481b590634cd1afd0576e7d1e1432"
    type :backport
    resolves "https://github.com/libplctag/libplctag/pull/618"
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
