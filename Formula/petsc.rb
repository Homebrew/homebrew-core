class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.1.tar.gz"
  sha256 "8e3455d2ef0aed637d4d8033dab752551e049a088f893610b799aa3188a5c246"
  revision 2

  bottle do
    sha256 "f0b8822ccaced996ac8140898c1bb8f38a97fac38e525e046f6a2474507e128f" => :high_sierra
    sha256 "50ee9271cbea0ba4ac922e2f018ded2ae3aa080efc834ec0109114f89d3e89a1" => :sierra
    sha256 "7534643b0690a8008ac7186c4e9ab0523d5a9a27d773cdccfa11be0f27515a27" => :el_capitan
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
