class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.4.tar.gz"
  sha256 "7c941b71be52c3b764214e492df60109d12f97f7d854c97a44df0c4d958b3906"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "19f998462e97687274dbcdd1143c3e1a1671cb9c3ef95257692da08afd355223"
    sha256 arm64_monterey: "e35ba44b8f1ed66d95cd00fd60a00286f1de824aa932eba08cc08a6424943863"
    sha256 arm64_big_sur:  "82c2ccd3186c6ca97db07d3b4b4204fe49192611cfc011ac86318443a18c12bb"
    sha256 ventura:        "d4c64b1a9c1283904d6471709d0239bc7e9e108b419e39e8758f760b1fcade0d"
    sha256 monterey:       "8837e8c8039567b063ea64f388a74a72644aae40eaae4b66fe14b0cb70ce3753"
    sha256 big_sur:        "ce8223ee289a0f1f23f4bbf5c0e98de865aa516f09723fab583fd38197eb989d"
    sha256 x86_64_linux:   "a89e141887463edcef8109302c7913603e50cd71b08c00fb59bfe3bc85b60b57"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

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

    # Avoid references to Homebrew shims (perform replacement before running `make`, or else the shim
    # paths will still end up in compiled code)
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", ""

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
