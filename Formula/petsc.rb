class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.17.3.tar.gz"
  sha256 "5c24ade5e4b32cc04935ba0db1dafe48d633bebaaa30a3033f1e58788d37875f"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "846ac0085b3e3d73568425f3591be0c923b6ac288f933a203af4fec6b9f98786"
    sha256 arm64_big_sur:  "45a61f15873ccfdfd3c8cb43c1d9960ad4675a95c4659f730156fd53c1098ea5"
    sha256 monterey:       "d82144fbf51b2ac0e654ecbe04b72155e0ccff2ca862dceeac17edddc0f95eb8"
    sha256 big_sur:        "bf3f6803645d7bf8a3716508976906b1af7bfd314b4f6545b4722828062a8b9e"
    sha256 catalina:       "151867f3ef7a1b13175c27564db1e6ce9ce3512845808c89e75c78eda0be91af"
    sha256 x86_64_linux:   "a7008b9d49f5bd82a2fd17952cc46ddd0c77180133e8b4e097baa877d6ffa8da"
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
