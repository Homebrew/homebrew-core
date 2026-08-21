class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "963dba33c6957586a30d40360f00e650b1842361c7838e16e5e8dc29feeb2cb7"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d174dbf6521bc23498a48867152738d6373a8d2baf406943cdd6686ff7756f1b"
    sha256 cellar: :any, arm64_sequoia: "975abf14fcb6a8e7b9668e59f1302631c7f4cb03389bb7db5b918469ebe3af38"
    sha256 cellar: :any, arm64_sonoma:  "fc7825d5ba355580955a9939496bb3d16c6624f272fb325652cd64f85315e99d"
    sha256 cellar: :any, sonoma:        "407fee90255c3e6d14b126b110419ce7b927df83fc3fc216dbafe65e359ecc5c"
    sha256 cellar: :any, arm64_linux:   "2227ce505d784c3d92890f682c5d1ec395b7500a16c90759e972f9b17244e9a1"
    sha256 cellar: :any, x86_64_linux:  "bd209d252b0cb5b07b363c1ebf2a5aab7d96905cc12aa886eb522b95f1748f23"
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
