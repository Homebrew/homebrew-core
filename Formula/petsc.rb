class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.4.tar.gz"
  sha256 "6173d30637261c5b740c0bea14747759200ca2012c7343139f9216bc296a6394"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2319865e350b0f12ad0a7346fd3f7a484e4f9d7e3be4b84c55a7f80956742af7"
    sha256 arm64_monterey: "304761ce505db555bbdb5f1f145b450625b922f4cc92db57fceae68635ec8f99"
    sha256 arm64_big_sur:  "57a176015836b8416cfda19d1d876e552609f55edf827eb2008d7a4c3d77df2f"
    sha256 ventura:        "5b856edabadeab753c51dd6ff8e8f0f9b1ad97ec6616e123630e337f21ffd476"
    sha256 monterey:       "569a60cc89fe85741f8d5129f1421a8505f715dbcb63d426a70356c41b4170e8"
    sha256 big_sur:        "d2ea36139069d771845a4a1e041235a91f56845a9929f5f403385f7c9cbb0748"
    sha256 x86_64_linux:   "94a262e709c986ecd301eeaea1db2b058f4810bd397066c4e3abd8fb3adcb5df"
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
