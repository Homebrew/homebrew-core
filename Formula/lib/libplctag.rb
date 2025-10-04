class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.11.tar.gz"
  sha256 "2d1294c915bdba127c92890ae4bf9cd2122d5b24685aa487f8a25c391c8476f0"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bee0d32f7c152b32538f7a16d912513d828441f37267cd688fd09aa9100fa83f"
    sha256 cellar: :any,                 arm64_sequoia: "ff163346688f8798d3f2ea038ce9a77a92758185a55a726dcd4c387bab1e0d55"
    sha256 cellar: :any,                 arm64_sonoma:  "b31170587c581648b6d0ff2c817b983a4969a7ba3d1ea0881b9580c7eba559c8"
    sha256 cellar: :any,                 arm64_ventura: "92e4b68260fc1941ff15a4c201114afd84faf2ee777e3e3f7f5f9ce120c10f74"
    sha256 cellar: :any,                 sonoma:        "0963597c29dfef1acb55b867961bc0606143f7dc83a2e61c6ed0a66075db6279"
    sha256 cellar: :any,                 ventura:       "8c0a81efbd684f5ca6044213bc15161b568cdf8fdcd064f031f94196b4f011c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9694ce8f6c1846711ff06309eaf9c0f2273e10245eac3f0faf0eb836404c3abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cdd65d06fdc0af99da9a94eb5c7d1c9f6f408a54d3806129eb9230d52cf1b28"
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
