class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.8.4-source.tgz"
  sha256 "760dbdc072eaa3c82d066c5ba3b06eacdd3304eb2a97373fe4ada9509f0b6ace"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2384b6b1d180c2e916771e9484b1503b7cf0e903e304e4e1bbe07fe76e7143b9"
    sha256 cellar: :any, big_sur:       "a545c00fed4aab78e77a4c76f4ad679268790e392cf6ab8ae5ee11e1e9a49908"
    sha256 cellar: :any, catalina:      "dcd0e5979c930c332a45575c6700af572a31675a2706c428e0b5737b50936037"
    sha256 cellar: :any, mojave:        "cfd4ed92de02f903a4a45e59c88d66ac8dab44d3867a4363f3d15c396fce41d1"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    args = std_cmake_args + %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
    ]

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
