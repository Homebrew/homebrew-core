class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.15.tar.gz"
  sha256 "f695ecf9666a029d0cc40ba8bcc3e3b781f4a0f763ffc0f45545e38e8a95a514"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aff64b8c92ab1386958f7854ac438f9227456c56a136fb6a948bed0682ddf554"
    sha256 cellar: :any,                 arm64_sequoia: "ea2201a50404fef1fda788f42024922ac87d74e9ea624a798bb0e22696b9b4bb"
    sha256 cellar: :any,                 arm64_sonoma:  "bc8aa1d8455ba736534030a43db0de757ee69fcfa0d19ac626da2598da3d57a6"
    sha256 cellar: :any,                 sonoma:        "5722b3c2de6172a7bb19469e86065fa2be3fd7a6e472f2992d3efc0aa55871c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73c996cb96cdd8414ed63c6ed62108da494508cf79ffd28315815c18f185b047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518cfe45d5e19a0a62f1fbc6b6d6e882c42c233b6c9add2d68c6bc11a3d770c1"
  end

  depends_on "cmake" => :build

  # Backport "ab_server: scope CIP_SRV_UNCONNECTED_SEND case body", upstream pr ref, https://github.com/libplctag/libplctag/pull/618
  patch do
    url "https://github.com/chenrui333/libplctag/commit/b19081bc35bd93893b343091add7d638ee3fe532.patch?full_index=1"
    sha256 "7b84abb42b4ba7b72b2b391f471acc56719481b590634cd1afd0576e7d1e1432"
  end

  def install
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
