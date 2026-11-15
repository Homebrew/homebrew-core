class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v26.09.0.tar.gz"
  sha256 "1274f62cb448f098cb793a44feb9e0b7f053ef6ef96b4eedb2dd6b4c67c92085"
  license "MPL-2.0"
  head "https://github.com/gismo/gismo.git", branch: "dev"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2b8e5b1042e508704bfc9c14528698c0dbfa0b2f922560b6c7064433da80ca12"
    sha256 cellar: :any, arm64_tahoe:       "e85fcd9adc1d0191fa065ee1c0fbb8e9d3d933e63650115bd652df46ddee97a6"
    sha256 cellar: :any, arm64_sequoia:     "7a5f1e092c3a19a90b5ed994d47eb5ff4f7e71f17b9e6cd97c9b6decf7c7b9e0"
    sha256 cellar: :any, arm64_linux:       "4664ad91ae588e7d450737e00f338912e96094ac98727206f5076561aa102f58"
    sha256 cellar: :any, x86_64_linux:      "d269c6874b8652e1326cb82f0f69fbf6475da24055cbc2f9d14489fb3b5bc298"
  end

  depends_on "cmake" => :build
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "superlu"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DGISMO_BUILD_EXAMPLES=OFF
      -DBLA_VENDOR=OpenBLAS
      -DSUPERLUDIR=#{formula_opt_prefix("superlu")}
      -DGISMO_WITH_SUPERLU=ON
      -DUMFPACKDIR=#{formula_opt_prefix("suite-sparse")}
      -DGISMO_WITH_UMFPACK=ON
      -DGISMO_WITH_OPENMP=ON
      -DTARGET_ARCHITECTURE=none
    ]

    # Tweak clang to compile OpenMP parallelized source code
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}/gismo", "-std=c++14", "-o", "test"
    assert_equal %w[4 4], shell_output("./test").split
  end
end
