class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "a3a9b2611676028e0e8d9b01e5b7d5d6c692ed40aa29ee4870e79c93387cf326"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a9b0472ddad7d24c370af3f426693296a1b008edb275216ccbe46709b7bb190"
    sha256 cellar: :any,                 arm64_sonoma:  "e1508990e17a953d8fc568e875facb0b61d23a540f6df8de2e739754cbb2b5ea"
    sha256 cellar: :any,                 arm64_ventura: "be7ade8533a2f0f0160875091c24e78aa8e052157622951a804985b0bf95c2e4"
    sha256 cellar: :any,                 sonoma:        "8040b9ac1da1dcbc5d97096f74ea8046abe48b2b2c94a033311f27b26d4df502"
    sha256 cellar: :any,                 ventura:       "7f9b32fa2e33193fe1dc459bc5677d22871c4ff993cff6029f0b97cae40e590d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8b254939aa4a60ee14f6365bdd4e0de514f22e860fb67661cc2c30fb6b3b8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acece6ddc38768cc8b3e8dcd8431fb6167e9eaf613bc667a5d47f6613ae47969"
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
