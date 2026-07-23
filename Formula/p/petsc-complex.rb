class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.25.3.tar.gz"
  sha256 "95ce60df2c7f9c5044d6a544c41e996a512557f91df1a60bdb690b332904ebb5"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_tahoe:   "f33b4740c6562ade95355e29099bf66948b2e4d09daa6fd23e1802fba798ce86"
    sha256 arm64_sequoia: "f81710e09a8e1907c3be1320e4ae1713513a9c9c925c1d7052a90c121d092b30"
    sha256 arm64_sonoma:  "ac1d8f75e7876e445875baa8a12d1277ebe73791a237053554b47cbb7e5700f1"
    sha256 sonoma:        "ee3427acd3908ad2ae9ccdd276f73152a1bb6f7ba80be6f44d0c7df5144cddb6"
    sha256 arm64_linux:   "ce464a030993e4e49ca2560b763f985df7816945458e320e5a37c4be634de2f5"
    sha256 x86_64_linux:  "87be41ddfacf711f12320fe804e7e682634eeedeff06a3e9f897e96254477394"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
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
                          "--with-fftw-dir=#{formula_opt_prefix("fftw")}",
                          "--with-hdf5-dir=#{formula_opt_prefix("hdf5-mpi")}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{formula_opt_prefix("metis")}",
                          "--with-scalapack-dir=#{formula_opt_prefix("scalapack")}",
                          "MAKEFLAGS=$MAKEFLAGS"

    # Avoid references to Homebrew shims (perform replacement before running `make`, or else the shim
    # paths will still end up in compiled code)
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", ""

    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm(lib/"petsc/conf/configure-hash")

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
