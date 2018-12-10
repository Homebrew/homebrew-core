class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.3.tar.gz"
  sha256 "8828fe1221f038d78a8eee3325cdb22ad1055a2f0671871815ee9f47365f93bb"
  revision 1

  bottle do
    sha256 "3159d87b2fb881890e3cbb8c2dcd815400321a0041c5291dbdb29585628cbf5e" => :mojave
    sha256 "679041473b4edbe331d89f4e15df8dccea99959b97fcb956bf62e14ff7622af3" => :high_sierra
    sha256 "89de145714cbb40b721927bed4b96cda0334da62d9107d541e89bf13a812e6f4" => :sierra
    sha256 "85b62f488b405282f84c943f5faf688766be4e68781b8f0ff0b9601472e6a13a" => :el_capitan
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc", :because => "petsc must be installed with either real or complex support, not both"

  def install
    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["F77"] = "mpif77"
    ENV["FC"] = "mpif90"
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0"
    system "make", "all"
    system "make", "install"
  end

  test do
    test_case = "#{share}/petsc/examples/ksp/ksp/examples/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match /^Norm of error .+, Iterations/, line, "Unexpected output format"
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
