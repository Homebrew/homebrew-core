class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.17.1.tar.gz"
  sha256 "c504609d9f532327c20b6363d6a6c7647ebd3c98acfb382c28fcd3852300ddd1"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_monterey: "a338dfa451742bbf78886ef38079e6b9057af4e3f2ec17731d71e2a473e09008"
    sha256 arm64_big_sur:  "8a8b53cb279da895c00fdeb4d7d65ca0ba51008554cdc4424114772a58b668a6"
    sha256 monterey:       "0eade73e085d7f80f337896459a57a38d8b2f6a58a9baa5b327a5641800fc266"
    sha256 big_sur:        "fb10650c1bfd7fdcb632ba43911ad8184ed6ca036381bcb123d45f5b05ef050a"
    sha256 catalina:       "a6bed7dea7a517378ab1e71a1ede781279fd84b3a83d4a4148eb79a82322f801"
    sha256 x86_64_linux:   "402ce9ac7abd721fb916d47d72d0f619f09ec99f1a7915ab9dd9e77158f213f4"
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
