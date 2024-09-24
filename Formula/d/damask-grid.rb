class DamaskGrid < Formula
  desc "Grid solver of the Multi-physics simulation package - DAMASK"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.0.tar.xz"
  sha256 "aaebc65b3b10e6c313132ee97cfed427c115079b7e438cc0727c5207e159019f"
  license "AGPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "hdf5-mpi"
  depends_on "petsc"

  uses_from_macos "zlib"

  patch :p1, :DATA

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
      -DCMAKE_INSTALL_PREFIX=${PWD}
    ]
    system "cmake", "-S", ".", "-B", "build-grid", *args, *std_cmake_args
    system "cmake", "--build", "build-grid", "--target", "install"
  end

  test do
    shell_output("$(brew --prefix damask-grid)/bin/DAMASK_grid")
  end
end

__END__
--- a/CMakeLists.txt 2024-08-23 15:51:49
+++ b/CMakeLists.txt 2024-08-23 16:03:44
@@ -127,6 +127,8 @@
 set(CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE} "${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}} ${PETSC_INCLUDES} ${BUILDCMD_POST}")

 set(CMAKE_Fortran_LINK_EXECUTABLE "${CMAKE_Fortran_LINK_EXECUTABLE} <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -L${PETSC_LIBRARY_DIRS} -lpetsc ${PETSC_EXTERNAL_LIB} -lz")
+set(CMAKE_Fortran_LINK_EXECUTABLE "${CMAKE_Fortran_LINK_EXECUTABLE} -LHOMEBREW_PREFIX/opt/fftw/lib -lfftw3_mpi -lfftw3")
+set(CMAKE_Fortran_LINK_EXECUTABLE "${CMAKE_Fortran_LINK_EXECUTABLE} -LHOMEBREW_PREFIX/opt/hdf5-mpi/lib -lhdf5_fortran -lhdf5")

 if(fYAML_FOUND STREQUAL "1")
     set(CMAKE_Fortran_LINK_EXECUTABLE "${CMAKE_Fortran_LINK_EXECUTABLE} -L${fYAML_LIBRARY_DIRS}")
@@ -140,6 +142,9 @@

 set(CMAKE_Fortran_LINK_EXECUTABLE "${CMAKE_Fortran_LINK_EXECUTABLE} ${BUILDCMD_POST}")

+set(CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE} "${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}} -IHOMEBREW_PREFIX/opt/fftw/include")
+set(CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE} "${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}} -IHOMEBREW_PREFIX/opt/hdf5-mpi/include")
+
 message("Fortran Compiler Flags:\n${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}}\n")
 message("C Compiler Flags:\n${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE}}\n")
 message("Fortran Linker Command:\n${CMAKE_Fortran_LINK_EXECUTABLE}\n")
