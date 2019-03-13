class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.4.tar.gz"
  sha256 "95004b65e43fefc6100f337a25da27bb99b9ef8d4071a36a33b5e83eb1f82021"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78104a835497727cf790f41ddbff68bd268b9968268e9d9f4d4e09c7e3cd6937" => :mojave
    sha256 "ef5438d14ad664a5cdd63014cdc813e4aab12933cc84fde49fbff3e6e267ed77" => :high_sierra
    sha256 "7f687cfc63d6664630f1f43986a444834dcea787b1410eff64322c27b2cbfa0f" => :sierra
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
