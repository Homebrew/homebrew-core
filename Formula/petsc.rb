class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.5.tar.gz"
  sha256 "df73ae13a4c5758325a9d69350cac423742657d8a8fc5782504b0e469ce46499"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5d9f0d9eeb9f8ce7dccc33980bef360bb7547ee87f1703388ffc269c162eada4"
    sha256 arm64_monterey: "98e849fd60ef492fc91706e1819a9deb1d84253c48d2234bd339321a3d375b35"
    sha256 arm64_big_sur:  "7f95d7d10b61f237ee80e28d414eaae55f7009a84a7a4717d4350afe672d10b0"
    sha256 ventura:        "d8523fab76c08390796b051bd3abd7e63117e0c673fbd6d9dfa8b7100dd91a27"
    sha256 monterey:       "4aae2e1ef99f51536684bf24490e6bbdc8e9215aa3864c4890f24fd04323d1e6"
    sha256 big_sur:        "fef9acfba634f244c0d5811bbc58c7715d1696047a2bb95e831dd49ec1cf0cef"
    sha256 x86_64_linux:   "833288bf3861b998c8b76b01bdaf2dd1e58ed704d2d6e617cecbfa5bbb471728"
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
