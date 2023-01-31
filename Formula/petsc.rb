class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.4.tar.gz"
  sha256 "6173d30637261c5b740c0bea14747759200ca2012c7343139f9216bc296a6394"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4fdf2028c8756a23afa45b6c024815b2c5289836a44184a03ba4b4862559678e"
    sha256 arm64_monterey: "2502de52b4eea9b174475325c03c0a9132caa2518641293e9acee77e863b56ae"
    sha256 arm64_big_sur:  "cf8fbdc49e811a03133041268858daa16e3996482d124400b39ba2c1867d9797"
    sha256 ventura:        "cc42247ea65c8726bed6d707e75b87030ea6dd6dab61a4e583913b7d9388357e"
    sha256 monterey:       "f5a566c44a25e49fa16e0ca0caafa0c255e6ae74566c15dc4fdb7a666733b149"
    sha256 big_sur:        "994c6d73559203b0c706c68823f57971c18b66e80883d473e35862f5ab394ea0"
    sha256 x86_64_linux:   "0e35f36568bf4f03827ab28003b4955199fdd9c343eab566cbfabac4d2f4a5e2"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

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

    if OS.mac? || File.foreach("#{lib}/petsc/conf/petscvariables").any? { |l| l[Superenv.shims_path.to_s] }
      inreplace lib/"petsc/conf/petscvariables", "#{Superenv.shims_path}/", ""
    end
  end

  test do
    flags = %W[-I#{include} -L#{lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib}" if OS.linux?
    system "mpicc", pkgshare/"examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
