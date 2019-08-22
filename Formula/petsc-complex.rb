class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.11.3.tar.gz"
  sha256 "8bee4a5ad37af85938ae755be182dcea255888b4f8b3d976bedc57e959280622"
  revision 2

  bottle do
    sha256 "a9b36192ab5650e69478cd351b082c6a011d60f9ea812915a6fae36d89ed61d1" => :mojave
    sha256 "970f3eea8d34b5e8646c81780f211c397a161d11b51c65574e48a09ccb9dc6b7" => :high_sierra
    sha256 "e8d605ae0771ecb8b6f18eea49344741efb615dd81937ad53eb4744d0411bee8" => :sierra
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
    test_case = "#{share}/petsc/examples/src/ksp/ksp/examples/tutorials/ex1.c"
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
