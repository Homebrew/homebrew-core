class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.26.1.tar.gz"
  sha256 "a4dc46c1b4403545ac2274741ce10801366c4a9a7b2683b678d18f6663b93496"
  license "BSD-2-Clause"
  compatibility_version 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_golden_gate: "10e3f698f81f51c11edc7a9b07363d49ec9b92d059cbdf6baafa5ac76e64caaa"
    sha256 arm64_tahoe:       "4d1c30d54079374865c74e5e726f7f89888dbe12e166dcc06eff3ed4aa42765f"
    sha256 arm64_sequoia:     "074ac70d6f0c79209d581ffd3f4ab78c1c40ee5b22ca5e4e38e82a23e4d9ce40"
    sha256 arm64_linux:       "14533cecd8b9b881d9faa448770bdd40fc92a1c3c761b0439bbf61416ea36bac"
    sha256 x86_64_linux:      "19300c0eed399ba6ac30fa8bc63fad9533b7d9edd8e95e38cd42310d94889b59"
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
