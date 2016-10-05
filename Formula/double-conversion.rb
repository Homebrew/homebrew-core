class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/floitsch/double-conversion"
  url "https://github.com/floitsch/double-conversion/archive/v1.1.5.tar.gz"
  sha256 "03b976675171923a726d100f21a9b85c1c33e06578568fbc92b13be96147d932"

  head "https://github.com/floitsch/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a314b7d76922e889a1dc0414b24d399a275459d2c3916e16921c74713593000b" => :sierra
    sha256 "727930169ce2bde673b86c5ae242c6641cf1a593902f5e7821981009dd4a2306" => :el_capitan
    sha256 "ffcf11a69c596f04cfb936cbc33a489f9f994b8fdaf66901f23e88a5638a4477" => :yosemite
    sha256 "648a9a7dcebe2abca8848a11c4647c0d3c85c6c49181100859277d24b8b71f62" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
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
