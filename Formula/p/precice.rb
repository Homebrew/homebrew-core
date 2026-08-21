class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 4
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2560f69ec542e81209a4ba60873057a0582469bcb27fec8ad9acb7fb6d8df8e"
    sha256 cellar: :any, arm64_sequoia: "8f1158924e9c6e1b513ef1d2c24cfa1986c96c555888563ecd112bcbb2cdd057"
    sha256 cellar: :any, arm64_sonoma:  "d5c034b5eb8ab7bafeba185c466ce995a619c66f74966552fc149f7d07bbaa49"
    sha256 cellar: :any, sonoma:        "deeef1e2e3ac12b3aaa6c1d8028b65cd4bc92c102b6ceb384bd4f6151b185c73"
    sha256 cellar: :any, arm64_linux:   "d2f280ee4336e69a8519524a87e143381f59e1ecf7fa6dd2c3e512cfc4a00295"
    sha256 cellar: :any, x86_64_linux:  "605e71842fbacbb44548fded27b8afb850d5c590d016919e7801d3f60737b2c5"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "ginkgo"
  depends_on "kokkos"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DPRECICE_FEATURE_GINKGO_MAPPING=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", pkgshare/"examples/solverdummies/precice-config.xml"
  end
end
