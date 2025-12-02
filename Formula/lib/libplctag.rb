class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.12.tar.gz"
  sha256 "420c37c11832eb3f000baa66bff087e79b3ca25cb4af978eb6de23a597911a13"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ded324ef409f272762a7304c86a1608d235fe2a59b8ce696e108a7730283851"
    sha256 cellar: :any,                 arm64_sequoia: "2bdf1111826c3d63ae9d0bf36fc71516578097e6c1db61613e2d69358a80643a"
    sha256 cellar: :any,                 arm64_sonoma:  "dc5096bbf6e4aecfef2b4c82485693e042482c0d67e610022a874a8e5e0a7003"
    sha256 cellar: :any,                 sonoma:        "5a0a6c872b0be0e836f08f0a5844878ed15c4dfc7715a8057345a3758ec0f26c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "795f174d6975cc2f0989c14ae2db0919b46eb5b50cb3b6a456d48eae24a4ccd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06ed36a97d76ea55cce326b049041c6a516de643e4f432a4d58096550886d71"
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
