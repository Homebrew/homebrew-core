class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.10.5-source.tgz"
  sha256 "cc030c5aee65e7d58f850b8b6f55a68945c89bc871f94e1239279f5a210fc4ea"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0289ba15e1a86afa889b673da095de28effddd2b1d5ed15f93fe124eb1a3f157"
    sha256 cellar: :any,                 arm64_big_sur:  "7ac80bc9a7a3677a01914e5411c5dc649fc4b063f08cab4babd3fc3e0fd653ce"
    sha256 cellar: :any,                 monterey:       "4e627ba55975476f8427695db5e75d71ee53aa343243af96195257d610e65db0"
    sha256 cellar: :any,                 big_sur:        "d3fd5dd366f9b3553831aaef3c65da7c8fd889a38ff8549bc26b4240c8de633e"
    sha256 cellar: :any,                 catalina:       "c5da13092830a31cd7ad5f0d54bbab303ef80a781e53c5eeb6f3cfb01eaca0c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a87c712168a4ecccac6ba730000ed592915cffaf0fa1e8fd75e1d4d98eb99ae"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_OS_SPECIFIC_INSTALL=0",
                    "-DGMSH_BIN=#{bin}",
                    "-DGMSH_LIB=#{lib}",
                    "-DGMSH_DOC=#{pkgshare}/gmsh",
                    "-DGMSH_MAN=#{man}",
                    "-DENABLE_BUILD_LIB=ON",
                    "-DENABLE_BUILD_SHARED=ON",
                    "-DENABLE_NATIVE_FILE_CHOOSER=ON",
                    "-DENABLE_PETSC=OFF",
                    "-DENABLE_SLEPC=OFF",
                    "-DENABLE_OCC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end
