class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "04ec44461850abbf33824da84978043b22554896b552c5fd11a9c5ae4b4d296e"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "98ff7ac5f00c5b3d65a3a335382b0d08e508ee9d6697064cb46d541d837b2975"
    sha256 cellar: :any,                 arm64_sonoma:   "5764a27a4392e020618a4a70c00d71f9a253419a55ae8c16dd965270eeb99cd1"
    sha256 cellar: :any,                 arm64_ventura:  "8945e3a31e2b8954f22e64dd6ebd1990bcf168151103264a8fcfd1eca21f9848"
    sha256 cellar: :any,                 arm64_monterey: "8280c82873f4b691376a017938aa3d3a1f59eb7b9e55130754d4e45fe4e0a8c6"
    sha256 cellar: :any,                 arm64_big_sur:  "4ab4afb8f5c68036a1122acadd11f610587ab139d1024be1713802da40867022"
    sha256 cellar: :any,                 sonoma:         "6df479d59d4b2f4b6ff88057175db4c04cb92ac9420cbe375f3bf68ca34a5ad6"
    sha256 cellar: :any,                 ventura:        "6841cb06c7313798c03cf02e2db00bc82f207a4a7e9c5449c39d25489b86f3a0"
    sha256 cellar: :any,                 monterey:       "7e9022b96cdce599dcf671a7a5e75ded3fd5111174cd16b12c01382e36486d1f"
    sha256 cellar: :any,                 big_sur:        "ed09e4f725aeb68de24babf7d76b340c024ae83dfda74b4cf588ea8bc27b5d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66164b85ecc6253cfbf62fe31224be35260f54fc452bae70a69b75f2ee96e0e0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "shared"
    system "cmake", "--install", "shared"

    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "static"
    lib.install "static/libdouble-conversion.a"
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
