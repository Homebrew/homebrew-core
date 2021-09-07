class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.15.4.tar.gz"
  sha256 "1e62fb0859a12891022765d1e24660cfcd704291c58667082d81a0618d6b0047"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_big_sur: "99ed99202f405c9927e0f1ada2a3621693f37c9e70f199a6185f05721a38be0e"
    sha256 big_sur:       "d89f0b958689f699860b9f40df6a463b2fc35fa396e57b2bd4aa1a4f292f54f6"
    sha256 catalina:      "eeec8f9d96f7d28946539cde3a1ea163fdbd983168fbe26c048f2082320c5ef3"
    sha256 mojave:        "646bfdb09e08a774445bdc3c138d590e644d9b449a701a534d7fabab8699186f"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
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

    if OS.mac?
      inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
    elsif File.readlines("#{lib}/petsc/conf/petscvariables").grep(/#{HOMEBREW_SHIMS_PATH}/o).any?
      inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/linux/super/", ""
    end
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
