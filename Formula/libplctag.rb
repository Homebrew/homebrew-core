class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.5.tar.gz"
  sha256 "8f3e36e79d15798e339324fafecf5540a1cfdfedb582f1dcc9ae09838a159b34"

  bottle do
    cellar :any
    sha256 "34e385d9ee74fd142bc998c09a386b19e74805e03efc3276c98799cd85267101" => :catalina
    sha256 "c4b28b272b84040536400ce5a45b13f21ea96be46136015e14d57154506a3c39" => :mojave
    sha256 "20872df137ecfddfbda5cd9b47249cf1b80cc7f6cf15dd8743d78b1ffebc6660" => :high_sierra
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
