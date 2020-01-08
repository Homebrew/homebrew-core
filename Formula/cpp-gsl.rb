class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v2.0.0.tar.gz"
  sha256 "6cce6fb16b651e62711a4f58e484931013c33979b795d1b1f7646f640cfa9c8e"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e981b4b2210a6705349862e2bcc044b0d487ae8723b9be20e90e9b1f58e0db1a" => :catalina
    sha256 "88805bdbc58c3279d13269592c9b0fe8fd6616efe8d7fa71f021f1f7a74f89db" => :mojave
    sha256 "88805bdbc58c3279d13269592c9b0fe8fd6616efe8d7fa71f021f1f7a74f89db" => :high_sierra
    sha256 "2179e8719714e6fbaeb8f0536bc38b6a1d24a39f3ad85b3f738aa7cb6955dbd5" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
