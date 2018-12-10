class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.3.tar.gz"
  sha256 "8828fe1221f038d78a8eee3325cdb22ad1055a2f0671871815ee9f47365f93bb"
  revision 1

  bottle do
    rebuild 1
    sha256 "b03109bfbe4896ef2326797e7726bb7cf4c9514a4ca0aef209f31dd3983e852d" => :mojave
    sha256 "a8f87b8dfda728cb297bb27b18d2238d50f6774086e9170698913597abfe80d7" => :high_sierra
    sha256 "6366422eb66c5b6d100fbfcb69e657f5f3b74807345c052e0a4a5d601ef27f60" => :sierra
    sha256 "d1e6494ab696ef49852a59e1e8e4e81a90f06da95ba8dfbf05662372580e7c53" => :el_capitan
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
    test_case = "#{pkgshare}/examples/ksp/ksp/examples/tutorials/ex1.c"
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
