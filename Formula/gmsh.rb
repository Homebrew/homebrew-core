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
    sha256 cellar: :any,                 arm64_monterey: "528c06c7c091279763a0a09f8c79293220afbabb3515d6656b2d6a69ff53a2cc"
    sha256 cellar: :any,                 arm64_big_sur:  "be4ba8e4010fa3d160e69e03de221c6f6bc83120e04e9f8a2a5a7ab22ac70aa9"
    sha256 cellar: :any,                 monterey:       "b7ecbe2f3ca865091ad1660f9a462e4ad12d62087363a851f27bbe512ce0fb8f"
    sha256 cellar: :any,                 big_sur:        "492627f27886d3a836c89adb31abe5ed21e165a0ee56d6210969fe0cd4bae1ac"
    sha256 cellar: :any,                 catalina:       "437ff76145413adea95620a1e9006ec7b79db873dd531f84438ff024d14d24a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e8b9a1f979daa8b01a99bd11d757b593903904609e8628ef7ee329fb9b8791"
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
