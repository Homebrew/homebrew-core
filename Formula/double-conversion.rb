class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.2.0.tar.gz"
  sha256 "3dbcdf186ad092a8b71228a5962009b5c96abde9a315257a3452eb988414ea3b"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "352b2b5e23fb43285efcae2e749c8b24fb8184bbb50e7a68f22d2a3b0c90567c"
    sha256 cellar: :any,                 arm64_big_sur:  "f97fd9898470577cd58fe742917ccaa32bc2697b87aabf25a3c7d08d2a8ece6d"
    sha256 cellar: :any,                 monterey:       "d479ea9e732d7d60c790ecf2ca4975ab34fb29b82274818c2204c4570b7aaaa1"
    sha256 cellar: :any,                 big_sur:        "affec63dfbab3c804d0263a7604d3b856c0a4caba03da76af8036aa19a4461e7"
    sha256 cellar: :any,                 catalina:       "0bb9d82a64fb8f478340bb2d7deb2df539f7c82553fe706c55b5d33d6f339877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a406e32a1377c5f9b3184d8dbda192e9fa051543775622397a732fa98d30a8"
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
