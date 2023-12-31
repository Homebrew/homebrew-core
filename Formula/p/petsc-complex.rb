class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.2.tar.gz"
  sha256 "2a2d08b5f0e3d0198dae2c42ce1fd036f25c153ef2bb4a2d320ca141ac7cd30b"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "956a9ee01fcf3bb62a2ab7c66549fbd01860dde033740cf03f9f3057472e4fac"
    sha256 arm64_ventura:  "7e42e77c6e2ba39a6fd14bcdb4f2054949e7a89fa878722bea0a1163c8c1fad0"
    sha256 arm64_monterey: "9b5b340e38ab5459a7102c4ec1a55b8aa1eecdedf10de2163929aea30c4c74e9"
    sha256 sonoma:         "d22f3966f9371f08b5ed47a11a7b0450476d44c35c08e9c3ce35788cd306c65b"
    sha256 ventura:        "a3a664ebe09f527391688a11050bbb1d6dfe87dbdaa576ecbe56c6913aa10bb8"
    sha256 monterey:       "eee334d54f81782b2d6bda4c4df9c659d9f33846e198e68442ceb9b4e2b0a5a2"
    sha256 x86_64_linux:   "1a448034cbb9c20160036191681c75d7332171aaa51414f075d8af7661c4642c"
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
