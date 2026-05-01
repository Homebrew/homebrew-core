class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ef4713c938a1b2000d0b071175e1b45f9ec55c7aec4bbe7b65c3992edcc74ac7"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ca16c163b36f0d115124712a61f2a4809b8911de069e97642d1ac8c21ac5b74"
    sha256 cellar: :any,                 arm64_sequoia: "b31411478c096a03cc8b24c42a78ec7e963251176fde430f6c0a6d56e695f02f"
    sha256 cellar: :any,                 arm64_sonoma:  "2f988d38ce801ca479e3e4167361296224fb59a9e7008946be7a696cd92efd7b"
    sha256 cellar: :any,                 sonoma:        "4b2c3d7c27f7507d00d3d92d22ca984f24aadec0f9f18c2a05a1a089e7cd2069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92fb9eb1b2f8dab23ac35c791b75c12d0b71ef6276dd79b09f6101cf13937669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0ef4bfdae534767f77e81ef979caa39ac34b1370ae4c24af87243391bcf26f"
  end

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "petsc"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"precice-version", "version"
    system bin/"precice-config-doc", "md"
    system bin/"precice-config-validate", pkgshare/"examples/solverdummies/precice-config.xml"
  end
end
