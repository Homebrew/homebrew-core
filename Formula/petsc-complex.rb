class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.5.tar.gz"
  sha256 "8b8ff5c4e10468f696803b354a502d690c7d25c19d694a7e10008a302fdbb048"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.mcs.anl.gov/petsc/download/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "656efb5c7d6717386e3138503c81cce9ae3c3c1bb8f99d3a4c00658578c74a48"
    sha256 big_sur:       "2adbf961b61d0690a6fc80669c464b5c22afd0952c0ca1000037b115822c1231"
    sha256 catalina:      "3defa36417b3fcb1db51a2250844b78583f5810e51ae8ed05ec8bbc8df63bd46"
    sha256 mojave:        "8aa9dd0fb3d3e3e7405534c738bb62d24953d6f35f10b756dca6a3ffad78a2a8"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"
    inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
  end

  test do
    test_case = "#{share}/petsc/examples/src/ksp/ksp/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
