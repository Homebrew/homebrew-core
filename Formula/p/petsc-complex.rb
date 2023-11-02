class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.1.tar.gz"
  sha256 "3d54f13000c9c8ceb13ca4f24f93d838319019d29e6de5244551a3ec22704f32"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "6cef68a4868821724f227b53a93ad1eafeb8fdd81ca74f6a18bbf82846095db2"
    sha256 arm64_ventura:  "296e121c488c41ac58289c805674234c8468bb659713e2e16ef26b93c70bb0d6"
    sha256 arm64_monterey: "279b402f8e81e1144ea796698fdbceea626f0a91a4eecd77508944208b99bc44"
    sha256 sonoma:         "3bfdf7f31e9beca77e0670cc6e6246e75bbd81ea67f632f5bd77ff81cb77f896"
    sha256 ventura:        "06d23a564bd3f5df0fa94ba7003f6b21f06a3e4d21e2ba11ae858df66e51d23c"
    sha256 monterey:       "3790aa6280558007f1b3268b92ffc15d58c5ae3e76132af965451b3c584c17f5"
    sha256 x86_64_linux:   "db0a4b954acf05a00febad69de279000eeb75869f61c2656217c4bab7821e292"
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
