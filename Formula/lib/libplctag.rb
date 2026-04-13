class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.16.tar.gz"
  sha256 "467d76fd8847819d412762df7ec70dbc2fc4f8f0ef4ce6d79bb0349ed3a4ea61"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3f745eb3e7792b7327de8c94ee99459ff54f45cecbb6b5c8bb65024e5bd30d7"
    sha256 cellar: :any,                 arm64_sequoia: "afba7335b90edde759d68698c3f093970bce3e5a4bf4889aa90c24a156cf85e4"
    sha256 cellar: :any,                 arm64_sonoma:  "fd1adab23619ccf16b8311445a1b6ddf821ada8b6ebd6143073422028b38c87b"
    sha256 cellar: :any,                 sonoma:        "8eed7d78cee2d90bd9f7a3c0552b28aaedc60f063ba5a8413c94d87d97b8a677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "559885be94842ee2f91a872aabe47b395849d428bde1ed8c53f9cf481c19d415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effba46edd11f2a975567c884e281992a150a143136cfc2a98395c22bdde4ade"
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
