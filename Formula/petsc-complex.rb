class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.0.tar.gz"
  sha256 "9da802e703ad79fb7ef0007d17f68916573011073ee9712dcd1673537f6a5f68"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_monterey: "add3259bf583a0e88a17161d78fe3e3535b1a727ffbeee0f74c1b4a77797d39f"
    sha256 arm64_big_sur:  "cba07b53973607eba7bac59b2c328208175a3a43f5752eb8db5d705b51b80b13"
    sha256 monterey:       "e35d25a9358c6c5e533c8e4c905f5e278ad2723996568e1103da28b5ed278f02"
    sha256 big_sur:        "07696566e19e83df7bb3cb24e27d130efad25f6eae005b33d166818991e40978"
    sha256 catalina:       "8dcff08417ccf2d3aafaa0451ef1deb498b219793c5b4a201b85ffbf12ab795e"
    sha256 x86_64_linux:   "f6f984b5b5ca0928835f694cc9ac04cfaf0b5273367fd3135b22630b6d4f7ebe"
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
