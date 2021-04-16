class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.3.6.tar.gz"
  sha256 "30151ac758a10e0a4be4ec0c65c7d9556f59b2b0d37271df68c0a26d4fdbed8e"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dff1e1ee1b1ead6084b0b96947f8db4f153ed7aec7cfe09bbe23fc9db0623ca7"
    sha256 cellar: :any, big_sur:       "86f61ac3fa8684cf51f71e0248c780ee3005128b3aef6803d0782fdc69dbeb8e"
    sha256 cellar: :any, catalina:      "6d7c10dc1b1c2e79232ed1b459a1ee7c18f1a32a08e3e9ec9cb2d248ad67b514"
    sha256 cellar: :any, mojave:        "b5c226870b5c1d0c7d0847121a00d6a17a59bc4cc807008686db9bcf5cbcc5ad"
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
