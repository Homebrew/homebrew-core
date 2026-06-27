class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "841f6e73e7352de0557d5782f3158e0e2f770943e62d5cdfeb12d5b84ad65e20"
    sha256 cellar: :any,                 arm64_sequoia: "757dc3095d5c4eec539da00e46b18b8bbfee24a0ecaffb4958d008675941bb6c"
    sha256 cellar: :any,                 arm64_sonoma:  "d5634c836d089b0e2570488dcfb02ee3211fa1c79a27d23a69f47d45c3c3e8fd"
    sha256 cellar: :any,                 sonoma:        "4cfae1f50c4be5722fe5a2ee98cef3da748b1e422c9e30ba4b3c6f3c91835b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c3638840987563f681eff6f907e7f55f0a42c968c8dd9c57bbde48c01627ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40ceb07952ea39e22be757eb52498f1768c862715228e4fda9fe4bb17e7fd80c"
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
