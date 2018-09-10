class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/3.1.0.tar.gz"
  sha256 "aef5f528dab826b269b54766a4c2d179e361866c75717af529f91c56b4034665"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea685a125c6a84ec8eba498628a91b18ee8417b4e0b2f51d21cdd125519287f4" => :mojave
    sha256 "ea9f34958fb3d97b9ed50446bbf784de9f86430e26b68229f46c86ea02cf2d67" => :high_sierra
    sha256 "70fe99bf8106928a4f7d1b8c94b7624d7dd18b29b37c13edbb711c19d2223ebf" => :sierra
    sha256 "b9d0e8483f1622b55cda3f1107c4264134758f0fb47e328edab279721b5b8c16" => :el_capitan
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
