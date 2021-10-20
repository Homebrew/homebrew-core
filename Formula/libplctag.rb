class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.0.tar.gz"
  sha256 "1849f23bc436bfa83feaf719b9af887ac79a99064816b0a52fa88acde7e6b0b2"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "01289ea1a8db82adbe4bd9cf2e99a42fcf77d29a54f3db5b91341c5918afa95b"
    sha256 cellar: :any,                 big_sur:       "6e02a23c1ecfc5bbe739638611de63e29da6c8515e72c812a7144b5c62209542"
    sha256 cellar: :any,                 catalina:      "aac1f8fa13bb852e84752bb6a922a6ebd77cc62b7ec682281c6640e42ac0f66c"
    sha256 cellar: :any,                 mojave:        "254d1b51b49e10089ce00123ede7310783bfa6a6f37609c42cc17d58596279ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bdbe8a3361b5827851d40a7348a89c573270adc21361a3a32668eec3c05087d"
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
