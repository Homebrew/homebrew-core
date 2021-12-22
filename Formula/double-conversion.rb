class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/v3.1.7.tar.gz"
  sha256 "a0204d6ab48223f2c8f53a932014e7f245125e7a5267764b1fbeebe4fa0ee8b9"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba80263bde683392415555020c38aa1d86e81f5ec14f2f7ade34bca13a78d148"
    sha256 cellar: :any,                 arm64_big_sur:  "021d47d6e30a4e1768cd51f8a9d5cbe0078ba006322b84dda0a7c65c31b00da6"
    sha256 cellar: :any,                 monterey:       "d389a17b220811792370cfa604aa57dafb176261076d363b5a778d825f1b00da"
    sha256 cellar: :any,                 big_sur:        "b58094fe44c3a64cfd22c9302ec2816b0df1e6d8a40351f70708d6046a65eda5"
    sha256 cellar: :any,                 catalina:       "1a2c54c892d245d1ddb3cfe8214f800c36a947df01abe9925754afc0638e05d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75bf94e7f5f4bbbd7ee74092985c70954472561aaaad14bb6bafc866352ce69"
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
