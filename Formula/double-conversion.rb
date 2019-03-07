class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.3.tar.gz"
  sha256 "63a75815708c76a51abfd1433fba76a02768f2c2ef558ef262bc99d9eed686e0"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5173ce53c54f9368ae8e18fb92f557c067bc74b889ce783b88acd07523908e" => :mojave
    sha256 "c7c7faa463dc0be1e89d5dd41c5569b87ae3c5369bd8b648c7541e9d5729297c" => :high_sierra
    sha256 "c11f0e5382d621b449a580a506bbf53d2e392ed6c83937244cdaa40d7f857d91" => :sierra
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
