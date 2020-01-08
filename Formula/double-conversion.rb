class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.5.tar.gz"
  sha256 "a63ecb93182134ba4293fd5f22d6e08ca417caafa244afaa751cbfddf6415b13"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f016bf145173af7242ce615b5764e123972e5c0c469908ea1e3c58793e7b829e" => :catalina
    sha256 "faa661750aeda3faf356d445d3d293fa52021c93a08fea35fd6666251b44203b" => :mojave
    sha256 "c948a1b31bc508f9218b6373e5ac3cc92838aa033e15f777aa046675921c3369" => :high_sierra
    sha256 "6fad17756240370dffc053a66fdfff4f17b02669c9456546a591349c3ea0e959" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
