class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.3.tar.gz"
  sha256 "63a75815708c76a51abfd1433fba76a02768f2c2ef558ef262bc99d9eed686e0"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f749b917ef7b94719212489781681cfe46ff65729c272d136282d62c8925759d" => :mojave
    sha256 "96f51c2d05fe260eefd15c9718a2a9ee332aad9d669f1311dec8f0036a1a08e1" => :high_sierra
    sha256 "279e9cd2113226f9ba4f6649fb16ceacf8ce664858cfb3eb0ea08146be9546f6" => :sierra
    sha256 "dcdac9ac3b9a2621bdbb190baadc85d332bd0bfb75663f80b0e3787e94f630c1" => :el_capitan
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
