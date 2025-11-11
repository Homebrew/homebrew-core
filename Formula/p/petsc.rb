class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.24.1.tar.gz"
  sha256 "d77f3fd5187a72ce5b68a056aa8fcccd37b6dc7a388991d1d8fa0bde32b0abc8"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/"
    regex(/href=.*?petsc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "aad92757a77a819f9414a1707f0866f713135e806e8a8198b710badc104c8f2e"
    sha256 arm64_sequoia: "2672e05670d0f648f60db2bdbbb63078e666cf2b63dd7cb33aa90f98613f7d94"
    sha256 arm64_sonoma:  "63a8ed53204c6a0995efa5d8a9595258fc580c9698470a073a970b99c586e8a3"
    sha256 sonoma:        "eb5be67a5e3930184954723e036ced4362f631226de371e0de06119d2d9371ae"
    sha256 arm64_linux:   "ab3d0d36e40c2d89460ce15dde009378e64ad254920f4172541aabcab0bb03c9"
    sha256 x86_64_linux:  "6cfd3b5c74cfb10ede31e0e6ca4a9fe8caea3dfdba1dfad57441bb60c45aeb77"
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

    # Avoid references to cellar paths.
    gcc = Formula["gcc"]
    open_mpi = Formula["open-mpi"]
    inreplace (lib/"pkgconfig").glob("*.pc") do |s|
      s.gsub! prefix, opt_prefix
      s.gsub! gcc.prefix.realpath, gcc.opt_prefix
      s.gsub! open_mpi.prefix.realpath, open_mpi.opt_prefix
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
