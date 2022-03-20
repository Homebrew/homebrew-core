class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.5.tar.gz"
  sha256 "7de8570eeb94062752d82a83208fc2bafc77b3f515023a4c14d8ff9440e66cac"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "54708a32a89efff00758cedfdc72129da481af1d4eb214ccf94e8a1bea207153"
    sha256 arm64_big_sur:  "0f2199b7972d3710db76b736a32a3b4da9ee06e2aae3ec8b0bbf94776ada7beb"
    sha256 monterey:       "a51b603c2bafe294ca2f5247a080f19c7172cbe7ae53b952c30a6d014378fe16"
    sha256 big_sur:        "866a53ccb0a46d4887b4bc114ff925468de82a3e19ab55fc80274a603df9f69d"
    sha256 catalina:       "f813e83a9213643067785849489ee8d64a76a10cc76a736388f563ce689bc5a7"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
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

    if OS.mac?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    elsif File.readlines("#{lib}/petsc/conf/petscvariables").grep(Superenv.shims_path.to_s).any?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    end
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/tutorials/ex1.c"
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
