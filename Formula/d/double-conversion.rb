class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "42fd4d980ea86426e457b24bdfa835a6f5ad9517ddb01cdb42b99ab9c8dd5dc9"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0954007c6e1b25d54f10e4c95144658a0f682c52c2b6880e1943ed6c95cc17b5"
    sha256 cellar: :any,                 arm64_sequoia: "62ed17d278c1feef69b809ac237e14eafcc42dc7bc9a27409ca43e33fcd149c6"
    sha256 cellar: :any,                 arm64_sonoma:  "03b3d8fce4e1baa082b32993478a9e286d1aaf300ec6a346fba0f779af5a5cf8"
    sha256 cellar: :any,                 sonoma:        "17621ed8f18ebe63f962d07321a602df40667125795e128c8accdcfecd739774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acba98e75abc255fa0b0a6279796590c947481d43da2d3c62ce655e8847c59bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e979034104679d840c699976d0c1c4f5ddb2d155e7ddf99752d682dfc0628fe6"
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
    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
