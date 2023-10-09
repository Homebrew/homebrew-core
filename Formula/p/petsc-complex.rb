class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.0.tar.gz"
  sha256 "c152ccb12cb2353369d27a65470d4044a0c67e0b69814368249976f5bb232bd4"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "885ac7486ecb57e3b84c540fa9f60a87caf6b46323a051f34787aec1ade4b94a"
    sha256 arm64_ventura:  "268aeff45a99991560690b8621a13d89ba8cb8c75118aeb453a6eabbdb534ad3"
    sha256 arm64_monterey: "dcb46612dd622cfc6bb0be54bfb6ead129241c35e3a251ec8b8b9b310c85f9e6"
    sha256 sonoma:         "65b72dbe85a15c8b593310b6bf7886b2b5bf6f3e58bac11040aef0e4b405fff6"
    sha256 ventura:        "6e047f24f3f195165db75245932ed52a4f6a6389c55a40bbd43e1d5f2f3d0055"
    sha256 monterey:       "389401ae44a238f8f32426b106c0df2b9b67ce5625250ac33f86d6a14e785423"
    sha256 x86_64_linux:   "5ad6e379d3241fb9cfd0f3f2d64b2f42fd557f264f772f0ff11dcf95d7fd7f3a"
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
