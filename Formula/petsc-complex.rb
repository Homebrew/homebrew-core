class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.5.tar.gz"
  sha256 "df73ae13a4c5758325a9d69350cac423742657d8a8fc5782504b0e469ce46499"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "6fc5f268f77e724accc30a15e03e36c5b930c2516d982483a66f09c190aca09d"
    sha256 arm64_monterey: "8172e37291f20bb620fc7ca2b5f4ea25aad1124424b538c0585e4c5de2ebd69c"
    sha256 arm64_big_sur:  "feba900a8f00998a8c714678f74958d3ea4d525dd328feb6cacd7a1ee1a34f6c"
    sha256 ventura:        "222dad7cffa6dcda1e34309945c3e692e49fc1e3f8a98aa78c0e9d8bae0d48ad"
    sha256 monterey:       "80a30f47d54f9316f66e9d070975b06e613bab98ee9056aff029dd2dff545361"
    sha256 big_sur:        "1ebf0dd3559cfcd4994e882ff1601a099b85c40107e2e24827290b62d9525a5c"
    sha256 x86_64_linux:   "0f98c48a3cd2690c453376341c1b04629fda31b288cc71661baeb78aad3d5d8f"
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
