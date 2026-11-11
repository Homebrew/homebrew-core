class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "cf60ae64b5f738a45c5bc06e39321c3b3a987f4115b401a30246222194797e99"
  license "LGPL-3.0-or-later"
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f55d1e23a00b34231e40b6eef30bed36a19f3cf32963ae8ffd2c960f0ffb8a5"
    sha256 cellar: :any, arm64_tahoe:       "86c45ec1c9a2272bac4b91e2c16e72426607595ec5959d31b2497c32cb8bdfe2"
    sha256 cellar: :any, arm64_sequoia:     "4ec45589d1feda4a4fb1d7cb6d08947c16436564db6310532b8eb9b4b454c9ee"
    sha256 cellar: :any, arm64_linux:       "46aed4fc03c03ce6a596c23f15d174167e23645fe3470bdf989e2fa2711c3c2b"
    sha256 cellar: :any, x86_64_linux:      "a9fc4732d2ea2bd646181ce637b58cbc695a39e98714ff4e21d685ea0b466c41"
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
