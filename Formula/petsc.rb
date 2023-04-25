class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.0.tar.gz"
  sha256 "8ced753e4d2fb6565662b2b1fbba75a426cbf8438203f82717ce270f0591322c"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0af5e9f6dd4b58351f778e97ffb3b40fa740ac4b4c1a80a8e5f03a38eed6a1c0"
    sha256 arm64_monterey: "f1b994801662beecd15960f03da97bb8f19856fe7b52d0d683b442fc8191cf16"
    sha256 arm64_big_sur:  "6a0e3b336915f93deae16da21af04ff48ec90a6582d511b8d054c2c2d790b2c6"
    sha256 ventura:        "a20da19799aef40c5f8ed99d0610d4a6f7f14815c2841dfdab089f9b50a3642f"
    sha256 monterey:       "b642061853423df02962545d221e1b1f295cc643e0e6c880771cc5993ed0b6f2"
    sha256 big_sur:        "88a4a42d9206e830d6305cdbc1b5974755be8b03966bf5b1de4d30c2e8b58bf7"
    sha256 x86_64_linux:   "2b0563775c7e964be4b3e0504303f1165d7935e2b7ed8ba7399737b494e8e60b"
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

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
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
    system "mpicc", pkgshare/"examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
