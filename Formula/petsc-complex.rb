class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.5.tar.gz"
  sha256 "7de8570eeb94062752d82a83208fc2bafc77b3f515023a4c14d8ff9440e66cac"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "5e3e8a01a0e82d929d8ee7119f958f38e71217fc16f3ddae66b5709c179eddf8"
    sha256 arm64_big_sur:  "2d22065446cfdde1a24c421dfa5cd8ccf69e17cc04f487dbfc52c67b63810a5a"
    sha256 monterey:       "964c00713ff82b2807b3f4736edaf63b77e36e40ad6f2341d61b34cb04edb5ba"
    sha256 big_sur:        "c8c2a70e4dda8f427973f6af204b95821577b3829cd1885bb9a1a558aa43c35d"
    sha256 catalina:       "ee72e59bfcc8fb8c094b1e49c4bc063ae9d8db0e11483155bee018d2e0a96685"
    sha256 x86_64_linux:   "cb9bee5b7c8563ec017abf14a38358058a8dc6d0c42d3f10db892667cb92f736"
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

    if OS.mac? || File.foreach("#{lib}/petsc/conf/petscvariables").any? { |l| l[Superenv.shims_path.to_s] }
      inreplace lib/"petsc/conf/petscvariables", "#{Superenv.shims_path}/", ""
    end
  end

  test do
    flags = %W[-I#{include} -L#{lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib}" if OS.linux?
    system "mpicc", share/"petsc/examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
