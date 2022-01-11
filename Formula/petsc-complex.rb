class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.3.tar.gz"
  sha256 "eff44c7e7f12991dc7d2b627c477807a215ce16c2ce8a1c78aa8237ddacf6ca5"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_monterey: "7bb34c8df0dcbe8f4464c9ccee4ddcf11a429aafa343eb9d650a5cd4d0af04cc"
    sha256 arm64_big_sur:  "29504eca80ad0abbce9d43793b2e9f118b366769343bb752df609e7310a207c4"
    sha256 monterey:       "7481aa83dfaa67c74ad46692ad7174fffbe2b238c802a2510ab7e606c3c8d83c"
    sha256 big_sur:        "5ca808e13c38653b83ac173d56614b2ae8b82e8f057da214ead12d733d54f7c7"
    sha256 catalina:       "84d5d3dc9007c914b94a74bbcf2d28595dbd74748729b3a5b2a0332a222f2544"
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
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    elsif File.readlines("#{lib}/petsc/conf/petscvariables").grep(Superenv.shims_path.to_s).any?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
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
