class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v3.0.1.tar.gz"
  sha256 "7ceba191e046e5347357c6b605f53e6bed069c974aeda851254cb6962a233572"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :catalina
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :mojave
    sha256 "abe62b73d3f81dab4d99bafc5dfdcc3b2640e81114b9bb43d9209af6e95d83dc" => :high_sierra
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
