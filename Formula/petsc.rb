class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.15.3.tar.gz"
  sha256 "483028088020001e6f8d57b78a7fc880ed52d6693f57d627779c428f55cff73d"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "009847eca600431ddc7cd7c69d009591e1b4e73c70e33e8b33be2c337f06a16c"
    sha256 big_sur:       "4d61a382a842bc0be05ccf462106edd5ddd13ee61854e3c566aba089112f005d"
    sha256 catalina:      "094a754feb280743a1320da6ce559fe67c26c88f85cc0ae161f9b6def819d0e0"
    sha256 mojave:        "ea0f8be5b92a1e8f08fdf38de826c810272ac827baddf414590b5b2dbc3da1ef"
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
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
