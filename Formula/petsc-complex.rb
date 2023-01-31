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
    sha256 arm64_ventura:  "2db2a37b26f7e832db5d80965d5b70c899158713b1fab24f6f912e466beff1f7"
    sha256 arm64_monterey: "8106afe6ae2e3ddeaac79b3a8044ed6298a23f296cb4b718a0c9ec0291c1b435"
    sha256 arm64_big_sur:  "7a4b1916c770a4c99b2262dae11a73b88d3b4a2dfdb8e24685d0c93caa2f7f75"
    sha256 ventura:        "a353aef5130c373bd0a2e69c2f95a20aa4bd4833acfb187a9840e44cc28feb85"
    sha256 monterey:       "17bf05d172bb4869d57cb80dcaf55c6497b9e90a3d4e83d656dc61ed4d66e27f"
    sha256 big_sur:        "4e0bac323b4147ef5b0c6243eda52909ef4654bfb562469eda2d0cfa00c75ccc"
    sha256 x86_64_linux:   "d766bc143720f43437cd99a32be8e1434769851a6d59bc209761688f22e63194"
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
