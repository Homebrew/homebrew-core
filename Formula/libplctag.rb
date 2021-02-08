class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.2.1.tar.gz"
  sha256 "7fa17a9bc82548daea5bc14e6d0e2aac45e684d96f866aa83bdfa7e0285174f6"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "40ffae5a14dcc47d0af848d74f5f070c96c32b918966b8312407c8ad36d6152a"
    sha256 cellar: :any, big_sur:       "0664ba0ed1f5477ef2b5967bc98ddf3936911d9a83d782f3928cb98cfc5e8494"
    sha256 cellar: :any, catalina:      "8c1072c0150e40bf21a646ba6417dd84585775f2f91a99340d7618d0c96bb76f"
    sha256 cellar: :any, mojave:        "bf0b9fd95a793393d4ab6c6bacc3398b073b1c62bc80702efe71910bf73584fd"
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
