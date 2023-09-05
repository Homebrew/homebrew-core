class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.5.tar.gz"
  sha256 "511aa78cad36db2dfd298acf35e9f7afd2ecc1f089da5b0b5682507a31a5d6b2"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "8860efc971bab34ec8ff7c7a2a261089e40fa94955b59d59ae2412c275aa04b5"
    sha256 arm64_monterey: "b502554ffbfb9c8a0d8b49462224b5c2992c871f8eeaf00c17e1341e5574dee6"
    sha256 arm64_big_sur:  "62da778b1ce86d6110ff560028e200caebc2ba4f77ec8b8f82570bae8b788985"
    sha256 ventura:        "fbf449fc6038629773841a15cccc98f812502dd8f8cc612621e233d30e542071"
    sha256 monterey:       "3ffbad54009029b2269ec77292dc309f28e0d49a5cf40a907a2463d4f1800638"
    sha256 big_sur:        "146ce5bd4b07a5ce8b887e81c0ab7469a8d0fe7c8ac33a6dabae3305731e5098"
    sha256 x86_64_linux:   "535b7eacbd5a4109b022ab81182f1554c46f6f76a62b129acea880a54dfcbd9c"
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
