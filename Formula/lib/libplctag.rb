class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.13.tar.gz"
  sha256 "cb204226a17459a44269302bf46fcda9aa3bf24f84ea9f25801aef6e5f42225e"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa4a5fc3bda90f1d3c024a39de9de655ad4221698a47a76152ebd30936d2ac2b"
    sha256 cellar: :any,                 arm64_sequoia: "49a52e1560cedaf548eea0101054cc51e7fc6a5477c3a455b3f8d144060f31cc"
    sha256 cellar: :any,                 arm64_sonoma:  "a5927805a61cc92fd291f3bbaf1ac43f684ef1d7dd0acdcc75414000b890b054"
    sha256 cellar: :any,                 sonoma:        "27ac7feafd0afdecc4e5e476467f6f46985fde068a93270b23147eb3b32565e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc974040343aa8351b8f26b1469cf8b2b0c42e9a1b42c7f79a3f2e5732d96cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d997648911d08752f523583ba71501c32b0ef375571f18fe95369c74db173210"
  end

  depends_on "cmake" => :build

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
