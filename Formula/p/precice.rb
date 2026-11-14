class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "cf60ae64b5f738a45c5bc06e39321c3b3a987f4115b401a30246222194797e99"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "73e96fe42575da52b7253d3821d5d243b0db01ae8bf5ffaaac455cca3419d2c3"
    sha256 cellar: :any, arm64_tahoe:       "106d1ff72b107c9b724d97e77426471f29e5deda55ae5d613302953191d29769"
    sha256 cellar: :any, arm64_sequoia:     "f0e4712c87ea7b64ac223e8ae12d120d5165c38bb0ca2749174e347b831f03cb"
    sha256 cellar: :any, arm64_linux:       "6d62f5878a286d804de288b0d5dbe43b92a22d3ea8b9fd742a15451b696dbf9a"
    sha256 cellar: :any, x86_64_linux:      "cb7bf5e9495f8a25ce6840c90da810ad84096bb595ee522431cbb821d26de224"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen" => :no_linkage
  depends_on "ginkgo"
  depends_on "kokkos"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.15"

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
