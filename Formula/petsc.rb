class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.4.tar.gz"
  sha256 "b030969816e02c251a6d010c07a90b69ade44932f9ddfac3090ff5e95ab97d5c"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://www.mcs.anl.gov/petsc/download/index.html"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5fb1d34ea1fc10e593d9159aa0cf26a60ceedb98065b172277b5227783f02819"
    sha256 big_sur:       "759dc30e93ccfdfa83fbfd799b7a880c077bb073dbd6d615cb18b7d032694609"
    sha256 catalina:      "290ac64b9704477ff27f20b3f9a7b1f58e5331c565e7eaa245fb1a35c7b985cd"
    sha256 mojave:        "b90aaa362215e8b3e00af3b2ba6abb247212fc2888c40c18411e85f9248d7434"
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
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
