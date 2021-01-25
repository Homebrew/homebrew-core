class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.3.tar.gz"
  sha256 "63ed7e3440f2bbc732a6c44aa878364f88f5016ab375d9b36d742893a049053d"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.mcs.anl.gov/petsc/download/index.html"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "0e97e5534d00c0a8a31d26ae076e75b33d46dbf455e1b798dd92f3ffeb38ed05" => :big_sur
    sha256 "53da9a4931a0489f7538753c3145337d16b5d4d777723c65ad6a01ef9cfe9b2c" => :arm64_big_sur
    sha256 "bce874f9194d5ab7d8843daeb9a1d300176ee2545ef31c37856f4407e7135869" => :catalina
    sha256 "35df8810e1276179fe904d72c50a4f4d6214467f01f7970171c8cb2356f8a979" => :mojave
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
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

    on_macos do
      inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
    end

    on_linux do
      if File.readlines("#{lib}/petsc/conf/petscvariables").grep(/#{HOMEBREW_SHIMS_PATH}/o).any?
        inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/linux/super/", ""
      end
    end
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/tutorials/ex1.c"
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
