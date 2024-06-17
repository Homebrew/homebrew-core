class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v23.12.0.tar.gz"
  sha256 "6dc78e1d0016a45aee879eec0e42faf010cd222800461d645f877ff0c1f2d1a2"
  license "MPL-2.0"
  head "https://github.com/gismo/gismo.git", branch: "stable"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "605f549b5ca06b4a101b74ef6b6cc5c215145dba3ba6ce5e696ea7ce6ab6b7e1"
    sha256 cellar: :any,                 arm64_ventura:  "e30d80cb9044585fc0e8fa6a7ccb1e1ebc39ea9ea25321e888c5081fc497c290"
    sha256 cellar: :any,                 arm64_monterey: "98cd35b9d1a4509767ffe8342fd675ae7ff4e17c540fafe5f150cf857a673f74"
    sha256 cellar: :any,                 sonoma:         "a91dffe15c5ec0d074f464540686b08978c8c4c26e454cb339e4e8ce9ef16f12"
    sha256 cellar: :any,                 ventura:        "c1b3311beafdd282b90dd8b0389774f051cdb8cafa3c0bfd2a37d8b2b96987a6"
    sha256 cellar: :any,                 monterey:       "36f513b6fd36d395a27c0e06170686e4dd0bfdabf63a45dd88174144c9b120ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed7f343c03afeaf7aaf94fc418947e0d3c0cce467f95f83c98ed95ae7f21aac"
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
