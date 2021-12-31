class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/libplctag/libplctag"
  url "https://github.com/libplctag/libplctag/archive/v2.4.9.tar.gz"
  sha256 "9c62fd22d1bba575c6beb479d5483340f00dfc9fc67dcb59a294a31f28b91c9b"
  license any_of: ["LGPL-2.0-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6190f338bc0bc7aa02a0fdff8fc9ec23d2e773c5e490cf896e2e50fcfdd16617"
    sha256 cellar: :any,                 arm64_big_sur:  "de3eff490a7a3226e6c9206642d02203b6694010353ef3e2d5ff3242da77b8fa"
    sha256 cellar: :any,                 monterey:       "b41939c877037da1728ac30c062f829cad3133ef6e4954ad7398d033005ed5ee"
    sha256 cellar: :any,                 big_sur:        "4286b889c5297dbb036e2776c60f8ec5de2e8b36a554e7cb5b5e95d45d001330"
    sha256 cellar: :any,                 catalina:       "0cbf016052e8a5a2c283e4546f74535501e194099b87e592133ef260939c4d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acfa15324294b703788462a9674f2327e753a4c4d074817630ac94cace3602e2"
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
