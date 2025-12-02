class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.24.2.tar.gz"
  sha256 "105c77cbc7361c078e013448bcad2c57ce8081377e5a8e49b3cc213f1a0a4a63"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_tahoe:   "535d3920c4ee4dc354c78756b2bd10792c4e561f9c1da1c02dd7656915c74cbf"
    sha256 arm64_sequoia: "11f844113857aec555161e83873385b7cd5ff583264df12ff2a5a839ae7b6b70"
    sha256 arm64_sonoma:  "92dd3a7c7aab9a1cdb5dd4afd93a98d950389a61314cba8c516ea486c13bcea2"
    sha256 sonoma:        "34f5c0f36817656bd136cc1e1fad4d56d82d5405618d38694e813923703522b4"
    sha256 arm64_linux:   "d14a43ae98bb0d83e206469abe83d834212a44762e794074106d3099373cc2ec"
    sha256 x86_64_linux:  "66466cf2a122ad8cf2126919c5cdba00bf39e16576252dfe39dd8f390d156ac9"
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
