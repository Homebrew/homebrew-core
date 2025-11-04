class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "300df9dbaec066c1d0f93f2dbf055705110d297bca23fc0f20a99847a55a24f4"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7c456e7082ab2a026dd0805cb3866760da48c6d599a72789298f37b56cb13340"
    sha256 cellar: :any,                 arm64_sequoia: "2f31dab890a00ca4dc49266f8126e6f33ebeff11f05cdcdc2bf95c9e6ba4d6c4"
    sha256 cellar: :any,                 arm64_sonoma:  "17de77b45778f8394d43423a7d6ed02624d033ce19d8ec8cb8adf024df77b7f8"
    sha256 cellar: :any,                 sonoma:        "751fa6ee50cf9bb085d3a89b95f9101391882d1fd3f3c3a2b18e5ca0c851e9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde18fbb9082d2bf672e311d5c1dc637210ed9be61cb05016806faf5ccceb378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bce6c711ca7ddaf61b96baaeb5aab43df83be9e0f45c149790ff0345c8cbeb8"
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
