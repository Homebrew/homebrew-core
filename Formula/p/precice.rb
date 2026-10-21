class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 5
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "de2a825c6ad45bd3b091169e23eabee1119a348ccda4a38b2a0882249d38c755"
    sha256 cellar: :any, arm64_tahoe:       "3bdad1f6a19415ce4058c2ef61bad6c7f624e7b96252a621d7540c910fc7dcca"
    sha256 cellar: :any, arm64_sequoia:     "f1834452ae249e05a6a8e60acc98eaea1264407b211fd7fe59d2badf7b2140bf"
    sha256 cellar: :any, arm64_linux:       "a75bf4c901dd22082eea0a9804b4fab69cc594de8d7085917fc7107f52d45a52"
    sha256 cellar: :any, x86_64_linux:      "ab85fe9e56fe9b9a9f6b43b87555e6417bd32df30978fab6cf2eab61a9bd2ca6"
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
