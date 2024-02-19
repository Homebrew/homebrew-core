class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.4.tar.gz"
  sha256 "b0d03a5595ee0a5696dd6683321e1dbfe9fea85238d3016a847b3d0bcdcfb3d9"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "3157ce303fb57de9a96317516dd2cd0a90363cea99f5487935214e3571b0f9f4"
    sha256 arm64_ventura:  "77fe6a93abd4a0b2a98af78e396f5cb0a9548eb9d81470a688caa94858f74ab2"
    sha256 arm64_monterey: "d468d250092064b599777c61943783a0f3d446e19287b7f5a8628365abca5287"
    sha256 sonoma:         "da5727813c8502fb204a78199ce4e6ee79d7775a179077482c20d4e6173873ec"
    sha256 ventura:        "b170fa9cb8e03860dcdad5653685a794c876c34c74850ca0e201737480697fd3"
    sha256 monterey:       "460bff864e4f7a83ec5048898182f61e3e5fcf42f27f926f9bb127cebc26c822"
    sha256 x86_64_linux:   "3fbb9df8abb9060c7035fad285072a4c60e465f36db2dc40dbedb640b83a2c68"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
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
