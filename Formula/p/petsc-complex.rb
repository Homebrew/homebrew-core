class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.23.3.tar.gz"
  sha256 "bb51e8cbaa3782afce38c6f0bdd64d20ed090695992b7d49817518aa7e909139"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sequoia: "a270b9d18b5a43f2634ad7f54b52f77e94a4fa6f8e508d007ec4005ff4ed37be"
    sha256 arm64_sonoma:  "a5aa4fa9f8aadfd3aca5d07e71f354adf20584999fc6e73ae8132561964d712f"
    sha256 arm64_ventura: "6681b2335e439eb559c3d2e8ab36aa6e1c6c45c3d0e158e5527e6df76798fefd"
    sha256 sonoma:        "2dddcf28ca47cc094ea334791a5553feec054490d61b0afbc450ef9f01745f53"
    sha256 ventura:       "1bd27a81d27a325abc1b591bacad34f8d49ce565f42fe825b9696dc066b182e0"
    sha256 arm64_linux:   "e55c7ec714461d45d135da91d7ea4b6fd2905ba220ad4b12dca6bff45cb640cd"
    sha256 x86_64_linux:  "d866af1bda598550a5c096b6ab1c1b6b702ed4b2a13fc35debbd894b4d3d4ee3"
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
