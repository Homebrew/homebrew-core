class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/floitsch/double-conversion"
  url "https://github.com/floitsch/double-conversion/archive/v3.0.0.tar.gz"
  sha256 "152f15355242b6b1fbb4098fcd825bf08527eda0c65e8446939222a13f0b3915"

  head "https://github.com/floitsch/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a90962bc9b0d25bd4d1c69e8892af60ffa4c8c18efd5653265debdad1736996e" => :high_sierra
    sha256 "bb2a51610649c9f86c06adc2ae66764a42b66e4d95166d306b05dff35e91e422" => :sierra
    sha256 "30a844eb4530cbe35e05fefed118fe096bf34de61c536283e6a1845f2f087639" => :el_capitan
    sha256 "dae47f87d852b0df160efaa57b1d2b81f96f31a8a2526e478f073f7fd0fc0beb" => :yosemite
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
