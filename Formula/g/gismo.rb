class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v25.07.0.tar.gz"
  sha256 "6d20f0b43ed80d3bf34fcabdac10a6bed6afbb314239dcbd0495a362a87aca9a"
  license "MPL-2.0"
  head "https://github.com/gismo/gismo.git", branch: "stable"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fd7006fc0945d60cb2d347a09f019f801c1527730b40730165c06ae76a88c842"
    sha256 cellar: :any,                 arm64_sequoia: "300458041bc09d87f28ef16f0071c0cc1b0024b87cda3da9c9ef65640c92019d"
    sha256 cellar: :any,                 arm64_sonoma:  "12eea2c988fcbdf05ca9dfeefbe47febab751e7c0fc6d7c90d79149f60bf90eb"
    sha256 cellar: :any,                 sonoma:        "ba784d2ae9dcca467f6d9e861669791ff1ec1fe366e5427da632c9af96ba5bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a85158fdc809bceb5bee05754ffa396d4b25c6d4899138121b29447f559656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a427d0bff623017d3cd0d7572ef898df0a0bef277788019c08a0a7c89a1a294"
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
