class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.1.tar.gz"
  sha256 "8e3455d2ef0aed637d4d8033dab752551e049a088f893610b799aa3188a5c246"

  bottle do
    sha256 "6404ca49a6462982c154f227f7de6e04ff6c17b463366007caec3ede24fd153c" => :high_sierra
    sha256 "996159b6d360fc3606c7ebfe95325628c52ab8dc902e746775944a30a5c25d5a" => :sierra
    sha256 "6a98da6a00692aa4c4e5d817785d00b23ddc212026c1b305dbebe28c18a1a0de" => :el_capitan
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
