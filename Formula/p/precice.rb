class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "300df9dbaec066c1d0f93f2dbf055705110d297bca23fc0f20a99847a55a24f4"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c369992ebd12bdb16dd31a53363b8a03faee3aae0b8830419bf162999367b3a"
    sha256 cellar: :any,                 arm64_sequoia: "a559bfae71fdf2ab1a8250538f487fd53b4adf2d2a642287cd85383dfeb6bcf1"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c8cb0c5bc5b24f49cf5c876bd7f8ede7dd7bf1f5e2fb4fbc2e75f9d7443e0f"
    sha256 cellar: :any,                 sonoma:        "5170843f508fb8ab70bcd9aae84cc1c7ae8a2da5f22e8ac14c7221c82732ff3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944a113c6ea1cc964160a2e4d49b88407f02a3cfa2a6f36986224794c784b1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c06e8a96d3389b8410ee2fc1cc975ce73f37e16a90c37da466a85637376a76"
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
