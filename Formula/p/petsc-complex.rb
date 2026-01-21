class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.24.3.tar.gz"
  sha256 "dde6f6ef2c5ef8c473a831d56a2e3192b5304c50c4cc5ded7f296ef6d86aaf13"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_tahoe:   "76f0ce654073a13aaf4f98af64df7643a86cb83903e9c99b96384498bcf3d188"
    sha256 arm64_sequoia: "0097c5be9e247d6695329733ac05edc554f88dc5ffa087ec04a1578d77b272c0"
    sha256 arm64_sonoma:  "a12325e77bffaf6a04aae4c2a5241586905cf2e9392661d076fc1c5b9bd7b871"
    sha256 sonoma:        "c63feb9ffe27219b83ce5c05b22988a1dc9fe392bec91e6ad7024315bd59c9b5"
    sha256 arm64_linux:   "a5ec085375dbc2f4ac8d3f1ce476f220337b7a737c52b130f5d885e14ba03d97"
    sha256 x86_64_linux:  "5a7f7118ceb00e14aca8938a8e11b3b55b25535a0597cf716f11b1950d98ab12"
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
                          "--with-fftw-dir=#{Formula["fftw"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5-mpi"].opt_prefix}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
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
