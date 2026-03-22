class Precice < Formula
  desc "Coupling library for partitioned multi-physics simulations"
  homepage "https://precice.org/"
  url "https://github.com/precice/precice/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "c52b22bd7669baec3ff903eba9bf102154629634652125a60b109a5b7e803ab5"
  license "LGPL-3.0-or-later"
  head "https://github.com/precice/precice.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06017d88e61cd6037ba3e281a462cd3b5a949c7feb6bd0361329d515e13ca564"
    sha256 cellar: :any,                 arm64_sequoia: "68dde149bf2cd6894e5b34aab1cbd6254f6775a3e1eb11d9224fe8c51ad56749"
    sha256 cellar: :any,                 arm64_sonoma:  "1e50c8c9d1f803081911b18718471fa6212992ee051ac00f77f97bc7ba50a64c"
    sha256 cellar: :any,                 sonoma:        "0dd151e2399335ae8caa1cc02edc266e389f79658329015afc981f3e8d97c4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d54f37577fb4adfcb8e7ee71f4a722b953fd43b1a6da957bbfef85e8385767e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4b27f5dda87bff3e4bf28384d24a837b129e5d49fbb2aa6caea96a29741424"
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
