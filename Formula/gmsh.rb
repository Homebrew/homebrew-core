class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.7.1-source.tgz"
  sha256 "c984c295116c757ed165d77149bd5fdd1068cbd7835e9bcd077358b503891c6a"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    cellar :any
    sha256 "81d53182a35db6fde116da54b6860e79e003b5af666e0a719737932803d4791b" => :big_sur
    sha256 "1806d59ab4b8c2b1c1bd6d71b784f7c2765367bce51d5049d00aa28695f9c6d0" => :arm64_big_sur
    sha256 "d26d11611cc961d8ca0473466e8dd0d0819d83409368abd6f5bc4877d0e89f8a" => :catalina
    sha256 "c0274b73227485be8f98de5f5166c2dd6fc32f52487c3f3cec8f0577be6d4039" => :mojave
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
