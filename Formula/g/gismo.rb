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
    sha256 cellar: :any,                 arm64_tahoe:   "cf57d6021c5640658228e7e4730e8fc4db43487a1f41b41f82762a70a4ab85ed"
    sha256 cellar: :any,                 arm64_sequoia: "f7b5ef891bbf14959a34beb2a22c25e6356af65846721437145ee3a91fdc9f07"
    sha256 cellar: :any,                 arm64_sonoma:  "1e8087112ce74db21a93335c87785dc48cb4ea4892cc82f01a54e2a0a66b286a"
    sha256 cellar: :any,                 arm64_ventura: "639c3f0f2779a419545c3e0d1fdbc56d792fb7f38be5bbc03bbf2032b5b658f1"
    sha256 cellar: :any,                 sonoma:        "e6cddae3701154c7eb9d849f6f040ca92051b60a42043012ed2a7b9d56016780"
    sha256 cellar: :any,                 ventura:       "9dd6d7d97c1abca6312a496c0a877f6257dfaf66d25c2f3e3f118043779c071b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6179384418da84074db83949a3def84a71f7a6ffa52003a792cbbdbf6fd5b9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820d285b212f7e9e7c758ce74f59b378331c7a5dc139e620c66cb69501e72b3e"
  end

  depends_on "cmake" => :build
  depends_on "openblas"
  depends_on "suite-sparse"
  depends_on "superlu"

  uses_from_macos "zlib"

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
