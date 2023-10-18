class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v21.12.0.tar.gz"
  sha256 "4001b4c49661ca8b71baf915e773341e115d154077bef218433a3c1d72ee4f0c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c8c82fbd61b63c8a3a8be5ee5a6e4449f4e683569f4562ed6a84a12ba3148b6c"
    sha256 cellar: :any,                 arm64_ventura:  "2c1e2f3e321ee74a7d53fab75dfa03d1228cb328b788eb65b5237d0c5c15c5b9"
    sha256 cellar: :any,                 arm64_monterey: "67fb8c504ab96451c1be3c590d81e424cb513f5bee72415c101c2dcf28b5d88a"
    sha256 cellar: :any,                 arm64_big_sur:  "25a1d59c5e94aad0861a99f63ad2adac55890eb35ba9ff997e4de69e334a15e6"
    sha256 cellar: :any,                 sonoma:         "6e0e723ca9011e0daa11f483185e080b63ed12a79c537cb81e9e6b497e858d55"
    sha256 cellar: :any,                 ventura:        "81ca83442c82f9e2b186bddc4c41afafbcd48543e1f4b824a82753a735616639"
    sha256 cellar: :any,                 monterey:       "1e62c2393cddcbea345d697fc2edc4f89b5e84ea0937d9833ee0b0995c855402"
    sha256 cellar: :any,                 big_sur:        "b866e490fa3a9f742caab85f3bb290c7c678f6a976be51f70855797066ab8cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc809b43a86065f48c301531493a3553f042c3990c6e2edabac31ed30bb54db8"
  end

  head do
    url "https://github.com/gismo/gismo.git", branch: "stable"
  end

  depends_on "cmake" => :build
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "superlu"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DGISMO_BUILD_EXAMPLES=OFF
      -DBLA_VENDOR=OpenBLAS
      -DSUPERLUDIR=#{Formula["superlu"].opt_prefix}
      -DGISMO_WITH_SUPERLU=ON
      -DUMFPACKDIR=#{Formula["suite-sparse"].opt_prefix}
      -DGISMO_WITH_UMFPACK=ON
      -DGISMO_WITH_OPENMP=ON
      -DTARGET_ARCHITECTURE=none
    ]

    # Tweak clang to compile OpenMP parallelized source code
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_include}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gismo.h>
      using namespace gismo;
      int main()
      {
        gsInfo.precision(3);
        gsVector<> v(4);
        gsMatrix<> M(2,4);
        v.setOnes();
        M.setOnes();
        gsInfo << M*v << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/gismo", "-std=c++14", "-o", "test"
    assert_equal %w[4 4], shell_output("./test").split
  end
end
