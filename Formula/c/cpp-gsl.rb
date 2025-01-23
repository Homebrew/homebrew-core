class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "0a227fc9c8e0bf25115f401b9a46c2a68cd28f299d24ab195284eb3f1d7794bd"
  license "MIT"
  head "https://github.com/Microsoft/GSL.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4133296b6d12d22ecc2f1a9dce98820203355a2481cc4dbcbfb1d1e371551a8d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DGSL_TEST=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
