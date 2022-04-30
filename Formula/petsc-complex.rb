class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.17.3.tar.gz"
  sha256 "5c24ade5e4b32cc04935ba0db1dafe48d633bebaaa30a3033f1e58788d37875f"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_monterey: "97babc7a350d36c8fa696306cbff0d4906b652f3b5a672b93a5f0321ceeb81ee"
    sha256 arm64_big_sur:  "6d46722500e45725724b718b563dad756875ffd8d51bfa0f884f514a58d5542c"
    sha256 monterey:       "f6e6d9146257a7cf49b27b65ab1f188ed0277261177b04ddf41211cbc9427c70"
    sha256 big_sur:        "07830c8a24ce233ab4b62fb1d7cbe35e87623967d07e5d7a76ba2f379f2b3c2e"
    sha256 catalina:       "95b198916c566a43316a30a2bd0fd661b6223164e2b487a0a1d7d6edb394826c"
    sha256 x86_64_linux:   "d612e1ff91bf50b3e485718077d07bfc33f61bcf72b9f5bd504d73e3524512c6"
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
