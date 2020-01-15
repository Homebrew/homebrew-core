class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.12.2.tar.gz"
  sha256 "c30bf8a005e850d1db137b7807a1b780286f70e650e5eba251061133ebd27f63"

  bottle do
    sha256 "ad47b16d531c95ad6ec9b7208967982f3ab3f5804aef5b013ebce035f69c90bd" => :catalina
    sha256 "605ec073e825b79639e233121f03ee4422b109f157712f0faecf196b20cfb7a5" => :mojave
    sha256 "fb34a3ac041a0dfa844d1f87b0ee1014bf6014d2cf48d17cc03a5ddb7e315467" => :high_sierra
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc-complex", :because => "petsc must be installed with either real or complex support, not both"

  def install
    ENV["CC"] = "mpicc"
    ENV["CXX"] = "mpicxx"
    ENV["F77"] = "mpif77"
    ENV["FC"] = "mpif90"
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-x=0"
    system "make", "all"
    system "make", "install"
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/examples/tutorials/ex1.c"
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
