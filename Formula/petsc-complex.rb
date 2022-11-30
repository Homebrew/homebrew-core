class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.2.tar.gz"
  sha256 "4e055f92f3d5123d415f6f3ccf5ede9989f16d9e1f71cc7998ad244a3d3562f4"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "2a49ab2d6a07745cd8f44841084850860734828fd4fb8dcd45261773ff5d0436"
    sha256 arm64_monterey: "5490282a75c17e8515cf468565632ca1b4eb15b929b26e5c2af1c663aeb2b894"
    sha256 arm64_big_sur:  "cc28a40ed41fbb27188617e1d5e0244916a29d13ef52a56309f9bc5161da1d45"
    sha256 monterey:       "9496ce9e97685e95fd2dc9a1cdf43d04216445871e32016d0aeea8e9629a1dd5"
    sha256 big_sur:        "9022d0077d0cfd290e939631e0c0f8426b246c135575b0e2d9c76e47e322c52b"
    sha256 catalina:       "ccdc0846799fa239fc0124655634bdd0ecca276c8dd5868aa0b7ad7eb3db3e5c"
    sha256 x86_64_linux:   "ba086667d19bc7d0e274d762babff968a64faef9f55ee2e1d5f6a7e261ef9fd9"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.10"
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
