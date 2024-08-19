class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v23.12.0.tar.gz"
  sha256 "6dc78e1d0016a45aee879eec0e42faf010cd222800461d645f877ff0c1f2d1a2"
  license "MPL-2.0"
  revision 1
  head "https://github.com/gismo/gismo.git", branch: "stable"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d0e50c9e6bc867c1f024a9787d5aab5bf1945540981ca0c541d03d6aa7dec3b"
    sha256 cellar: :any,                 arm64_ventura:  "5edbf2c3302567020d39a374d37658a45586af67887b8f572a3b44b800441e24"
    sha256 cellar: :any,                 arm64_monterey: "9a7078fc694bb1ba8458584b7756165c66da692de548e7f41089153dfcdc0204"
    sha256 cellar: :any,                 sonoma:         "7f848967b119fbe5961df3cb422d4a61e06558d99cbfaf091f3135fe075a423e"
    sha256 cellar: :any,                 ventura:        "b63e5e4c6ce47c361cb50c886abed10603489061c7f4ad971aada97896e62c78"
    sha256 cellar: :any,                 monterey:       "766cbd0a43cc5a721671c093555129781241300a8e0e8dce497e8bc2699ff482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9731ddd067e2566dfeef378fd936203dd6651ed460b1e2b9e53528c63882239a"
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
