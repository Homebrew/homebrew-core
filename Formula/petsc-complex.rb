class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.2.tar.gz"
  sha256 "114f363f779bb16839b25c0e70f8b0ae0d947d50e72f7c6cddcb11b001079b16"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "8656ff8e4eeecbd0680d20d8c179871c5ee1565305558ab7c0e1d55dde6cbc14"
    sha256 arm64_monterey: "cfe50cd4f37ae69400d26d973f791e882afc832f9009eeeee130b3b2de526278"
    sha256 arm64_big_sur:  "005f0012349697818359776acd2c90559c3cd29a0f7bcc6a4cb0cb8e348e1ad8"
    sha256 ventura:        "ad23a6442559dec9c5401690a3296fda53508895cb0a289a6951d316b3cd8445"
    sha256 monterey:       "9c62d6a56d83ed9f43bce534132d4c8fe9c017c6d302806406203cabdd8bc363"
    sha256 big_sur:        "59da9f5a1daf3748dc3d0ad51c37fa724a7aade3dde8b3103fc4f266d827750d"
    sha256 x86_64_linux:   "ed298cf2d8a6d2cb0139137d68c52c11cd3c79c98c8bf087bdacdc6b81587a45"
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
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", "" if OS.mac?

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
