class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.2.1.tar.gz"
  sha256 "e40d236343cad807e83d192265f139481c51fc83a1c49e406ac6ce0a0ba7cd35"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "208098fabee3e07ea7ef4fa6f95ba28d0dd461d17df90c33d23b95b280b642e3"
    sha256 cellar: :any,                 arm64_monterey: "dcd8a50bf98490fae00d73325210c5f9f65f1b20a59a1979afdb28e9c91d3ba9"
    sha256 cellar: :any,                 arm64_big_sur:  "7996dcb8fafcc3aee6fee04da51533a15f297cb34de699a7ec0cfede53f4447a"
    sha256 cellar: :any,                 ventura:        "8c37957d1059538da20b3d562b59abef18239b662c57d33e4a5d1b1f115965f7"
    sha256 cellar: :any,                 monterey:       "ab33e3194744d91e611c402d1f5ed5243ffa7bb9a776abec12b05d674b210880"
    sha256 cellar: :any,                 big_sur:        "f20cd36d2cb176b5ea9e5bbc15241f7a2f57bbea16196adfaa0ee51918541992"
    sha256 cellar: :any,                 catalina:       "2299213ea5c53ce8c80818d0256911227e7dd9f3c444eff84993d7b266180a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad1dbba4e56ae238b08b842855f8ca8ca1c929644a09a9f91c24d4c7fafc2e9f"
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
