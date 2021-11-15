class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.0.tar.gz"
  sha256 "5aaad7deea127a4790c8aa95c42fd9451ab10b5d6c68b226b92d4853002f438d"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_big_sur: "8aac66bae6ddb59ad3ac4c93285b0353fb80ca9460481b9cb73cf95a0544b9ab"
    sha256 big_sur:       "4ec9893205112d29dd80c50b105a54abf6f23580828a8117f4a1b32b8661e62d"
    sha256 catalina:      "63bac9da17e984c5296ba8aa1ca88e2cfbcb2150a8ff79da723aa5619e921987"
    sha256 mojave:        "e157b6dc2fdd68d86d3b90f4d5baf1f968aa26929dabc763812861d9663bfe19"
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
