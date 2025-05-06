class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v25.01.0.tar.gz"
  sha256 "d1250b3d3a37c9d7d3f9cb63e4a36ae07b76aa47335847008be7516cc390c61e"
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
    sha256 cellar: :any,                 arm64_sequoia: "0d9ef9f132c2b82020b765e47616508bd9def1f8f86d4f7df80cd4634d14b71e"
    sha256 cellar: :any,                 arm64_sonoma:  "73968e5e169f150fb150bb800a0f1890c9505e913cebe465cd5b91c191ab17ca"
    sha256 cellar: :any,                 arm64_ventura: "3119c3a59c2b2a28875eb6e40eafd5889da5bd62f698c269dfe4b05f30eddf10"
    sha256 cellar: :any,                 sonoma:        "992c1d9e553767311d57b918950ed5bf1a67847f4847ecd8130a783d36f7a745"
    sha256 cellar: :any,                 ventura:       "8be99fca669151b6be0f2082abe7c8fa55f68a613fa63d76b04e257773abc1e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58de1dc7a347fcdb0b09fc03d4fea99ba9bfa29cc38c94def18254630095a46d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f6aebd7ab833f834c834c129b0aab808a62f9d3d66aa19281d4ed6db0277a2"
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
