class Apbs < Formula
  desc "Adaptive Poisson-Boltzmann Solver"
  homepage "https://www.poissonboltzmann.org/"
  # pull from git tag to get submodules
  url "https://github.com/Electrostatics/apbs.git",
      tag:      "v3.4.0",
      revision: "ed52c8c04406b8e4744de628557b47deefd4ecc5"
  license "MIT"
  head "https://github.com/Electrostatics/apbs.git", branch: "main"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "eigen"
  depends_on "gcc"
  depends_on "metis"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "suite-sparse"
  depends_on "superlu"

  fails_with :clang

  def install
    mkdir "build" do
      args = std_cmake_args + %w[
        -DBUILD_DOC=ON
        -DBUILD_TOOLS=ON
        -DAPBS_STATIC_BUILD=ON
        -DENABLE_GEOFLOW=ON
        -DENABLE_BEM=ON
        -DENABLE_FETK=ON
        -DENABLE_iAPBS=ON
        -DENABLE_OPENMP=OFF
        -DENABLE_PBAM=ON
        -DENABLE_PBSAM=ON
        -DENABLE_PYGBE=ON
        -DENABLE_PYTHON=OFF
        -DENABLE_TESTS=ON
        -DPYTHON_MIN_VERSION=3.9
        -DPYTHON_MAX_VERSION=3.10
      ]
      system "cmake", "..", *args
      # Use Homebrew's superlu
      inreplace "_deps/fetk-src/punc/CMakeLists.txt", "set(BUILD_SUPERLU ON)", "set(BUILD_SUPERLU OFF)"
      system "make", "install"
    end
  end

  test do
    cd prefix/"share/apbs/examples/solv" do
      system bin/"apbs", "apbs-mol.in"
    end
  end
end
