class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.2.tar.gz"
  sha256 "4e055f92f3d5123d415f6f3ccf5ede9989f16d9e1f71cc7998ad244a3d3562f4"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0bccffb32dca92e00cf9338eb950c342dfca6424ff1c7dde638302a0f277ef4b"
    sha256 arm64_monterey: "9a7c137dca516b8dfd02460a5cf3cc9eecfad8176f632057031d9fe88bbabaa3"
    sha256 arm64_big_sur:  "bf6b25fbaf59fc904391546886f29e03aa72164b7cc5cf5d3aec50840f617d68"
    sha256 monterey:       "8c70c6e76ca76c58c98c75b4f777d6a731a5867ebb45bf00220ff06698d1680c"
    sha256 big_sur:        "28d117b4b39877db4ca40fd5f5ff811f25e70bc73bb5e19c69be041f78a9e40d"
    sha256 catalina:       "399a02976662c5f981f91ebbc6a84aec7ca623e4e6b3f8a73d9998642938ba9b"
    sha256 x86_64_linux:   "f63518c8c7dbe9a361e8b3d0d91c5932ae5295b87d4adef6c4a2b5b21e9e057f"
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
