class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.5.tar.gz"
  sha256 "fb4e637758737af910b05f30a785245633916cd0a929b7b6447ad1028da4ea5a"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sequoia:  "b011fd9da06732ba95b9f41b746fae0d6dc511f1e45a90d25949845a9604d907"
    sha256 arm64_sonoma:   "79474f5eac3712c82a73ef28208f32f129a722920ef2efc48061ee6ed82850a1"
    sha256 arm64_ventura:  "bfdee742583b9fc2d3b1609e837a8b659ea554f0f9d58c232ad6bbe83d3a49bc"
    sha256 arm64_monterey: "a6cdd1fbecd38ce9a502c89a426691a76779b9e2cfcf57f342316dbe385eacb6"
    sha256 sonoma:         "e0598cc3ecc9c0c2a52d78fa3b28b8c1e9d3846151d1b73b1b605be2a86e6dea"
    sha256 ventura:        "90eb7075046e1e7afb15a64429e95419ad0b7ac8e3c48f6ff430f183a7f30f6f"
    sha256 monterey:       "02c918d0fb776665e9648f07727918f4f99938511cde34a7244c7043349e9e24"
    sha256 x86_64_linux:   "c63d9a17db67e029d8dc5f783b804efbd7152063451b6f305c3231f88bd2b6a5"
  end

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
