class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.25.5.tar.gz"
  sha256 "6d61c472db39006d261542d1a42f1fa6c52d6e89f9e77041386189aa8c24b490"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_golden_gate: "16c98434aeb6c703bc64ccee8290b67638456abfcaaac7428cabb62298140aed"
    sha256 arm64_tahoe:       "9f06d4b805ded4054e30a111223984aefbaec206b5c78d27ae0c7142561328c7"
    sha256 arm64_sequoia:     "135626b0125b31f2b39c7c684529dff4d1f89cda4fd728e41784a01408519f6b"
    sha256 arm64_sonoma:      "b42c430ea65ada14e5d64d837cb23ed64bc46179ab90e755cc5bf8d444c98e43"
    sha256 arm64_linux:       "25714b37da187eed13038e051d228e666201cb2a2ac902e9554d9c660af98e8d"
    sha256 x86_64_linux:      "d66bb400150ed33018e78b3316ef96c28879e63e5893aa08b3659f0184d78041"
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
