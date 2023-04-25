class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.0.tar.gz"
  sha256 "8ced753e4d2fb6565662b2b1fbba75a426cbf8438203f82717ce270f0591322c"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "bec90071af314416598048baffd5aa06a54c4cec2964d67a00695b449a3ea0b0"
    sha256 arm64_monterey: "2b4588e0323f12fa9bf339c5cf7b520a5aac7d8e931a00bdeb776c1c1fdaeabf"
    sha256 arm64_big_sur:  "f85159e1d56b5d3216c9febae1f7a8acfacd330e9574781052b14375219e56bd"
    sha256 ventura:        "411f170228cd0a6fbc7597c48a02c39b15cb5cfb3c05fb4c07479f6c9818a0fc"
    sha256 monterey:       "ad1109e65f31a4993f9c36707cde217ab9f19a567346367d88fbe591ce53e8cd"
    sha256 big_sur:        "1ca0a889e86bab45805d8c59246288aa3d366b897d87894ec455bfe82f1960b6"
    sha256 x86_64_linux:   "a659f1b8d3a14c02e589d5cec2b7e523e76ce19e0642411ad4d5724621234085"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
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
