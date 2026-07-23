class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 2
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d91efd5606ff676b57654fd0eb6d29f034bb365dbe2a73c09192d482a33cb5c"
    sha256 cellar: :any, arm64_sequoia: "f7895b55d96088f80003f66b0002a93fc15a8062f1866d35ed61fb82cb72f416"
    sha256 cellar: :any, arm64_sonoma:  "454910e27028958ee40582ecd4b6523a724092bc70b067b6b3279f62a0774555"
    sha256 cellar: :any, sonoma:        "939aeba137cc54b7e4a9ac89bbfc7f5ca241854e4f29a9aee97f2c9dbe4b8283"
    sha256 cellar: :any, arm64_linux:   "2b1b9596f721f29a266b2e42441635e214fd16897b08b839035ec476cf58ee6b"
    sha256 cellar: :any, x86_64_linux:  "398c52923858b6a5f2b6709943e798a3940c666390d392cccdb2b7093721ee29"
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
