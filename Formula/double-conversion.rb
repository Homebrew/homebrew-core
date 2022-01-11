class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.2.0.tar.gz"
  sha256 "3dbcdf186ad092a8b71228a5962009b5c96abde9a315257a3452eb988414ea3b"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d627d25a62f2676f3977dd2001f99d6b6ec00ac1297b682a3a28b1f6a2378100"
    sha256 cellar: :any,                 arm64_big_sur:  "e2d2777917015468fc626f90340aceea357c644dfb4f6af8080ce577ec66374c"
    sha256 cellar: :any,                 monterey:       "9aa635e1048ea42d5242a867a538fa5689e25078e75b4c643c4a4234cf911578"
    sha256 cellar: :any,                 big_sur:        "b12bc5e7981c0ccdd2a69e1a9dd76627de9c712e0efb7128fffedbac8d4404fd"
    sha256 cellar: :any,                 catalina:       "2aa2c11ee0d8c58d58c7e1b3fc083326ed9248300cb1aadcb4776b41d67993ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c369ccd5f912a3e9d3cdebe0b663a22f19dfaea14c22b6e3b2feab5f6180b35"
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"

      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "libdouble-conversion.a"
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
