class Gismo < Formula
  desc "C++ library for isogeometric analysis (IGA)"
  homepage "https://gismo.github.io"
  url "https://github.com/gismo/gismo/archive/refs/tags/v24.08.0.tar.gz"
  sha256 "ac6e7fc9d40aae698f3451a62dbbe45d9c62a40dfd1caf690b4d10eb624bcd6a"
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
    sha256 cellar: :any,                 arm64_sequoia:  "81f64510e378ee3dd6d5daade203105cd70ec9ceb7d4647b16e2dd270f50fa0b"
    sha256 cellar: :any,                 arm64_sonoma:   "6fd07b2b22aadf7b26e6525b4212f93136236e5b92a403f0540eb2bb4bc1da47"
    sha256 cellar: :any,                 arm64_ventura:  "09105af8414d9dca9fd4846dcf5db6be8c1ba7a05e3b7f40363f96b93cc7821b"
    sha256 cellar: :any,                 arm64_monterey: "449e51f74e29a3d573aae1bc051a8c011e6ec4923d8834501b151835cba04f88"
    sha256 cellar: :any,                 sonoma:         "25899a5738c7805c331cfab2e769cb112bc41a52509f0f33750059e9d1168c6c"
    sha256 cellar: :any,                 ventura:        "d57ee5936c178ac9b3138da945ac02e6ceb188f007715d042bc6f49bf3f47bdd"
    sha256 cellar: :any,                 monterey:       "24feddeb684724c75901920269ef7c6ae9429a3169172c3314b864d7a3fc1e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "288910d513ee1404ccb986c5159f37a39076deffbd1b55d0b261513c41335a81"
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
