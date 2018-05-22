class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.2.tar.gz"
  sha256 "65100189796f05991bb2e746f56eec27f8425f6eb901f8f08459ffd2a5e6c69a"

  bottle do
    sha256 "9c817bd47333c272b7f2f8781cc69ffd689704445c7b66d136aa27780889c7a5" => :high_sierra
    sha256 "ba63ad7efd234e251903839f079c63c205da0eabe2bc438c216534bc01556846" => :sierra
    sha256 "26c299e53ee0ca68ac26dd9328522e695ab9c3c42683c0c1f0ab63e8273feee5" => :el_capitan
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

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
