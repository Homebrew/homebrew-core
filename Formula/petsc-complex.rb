class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.4.tar.gz"
  sha256 "6173d30637261c5b740c0bea14747759200ca2012c7343139f9216bc296a6394"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "e27eb154a5387d5b1e7f481b7c9336e264b19b733841cd31f20017621bb8b5be"
    sha256 arm64_monterey: "29408cb52a1227904f5f60bc25fca0715301c3c0ac3f2d27194cbdc1b01ac2f4"
    sha256 arm64_big_sur:  "eaf5ff3b2c9dddfb016472329030c397ce786a52c499f82bfb163841c03e9f88"
    sha256 ventura:        "b888a6f56e0147c16752d3524a5aaf805c372d75de7881cc8d48a2f5fb881158"
    sha256 monterey:       "ec202b46e57b92d8d4c41b918c8add13e0353aef580e3cb05c4dcaaaeef331e4"
    sha256 big_sur:        "025e2afae506fc4cf0a4b56f67a21bc9304076988f3e62ea9c6b6ff66767ae41"
    sha256 x86_64_linux:   "fbb48c1916b197199f5e57b57f1a218a57ed1eaa341fefe455725edf66f44dd0"
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
