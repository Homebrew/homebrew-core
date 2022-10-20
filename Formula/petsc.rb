class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.0.tar.gz"
  sha256 "9da802e703ad79fb7ef0007d17f68916573011073ee9712dcd1673537f6a5f68"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "99a04224f3b0166333d5a83fc6b4cfee6610b58983881ead89f17df0eec77045"
    sha256 arm64_big_sur:  "8610d9e35028c948e8c793bdf1b022ad3400d628d358aed525ccc5f42d407aef"
    sha256 monterey:       "ef29b0e919f2184b080d200d2f5379fdef55a5b9c35cbe86f99c0ec9affb4b64"
    sha256 big_sur:        "90ebe50faed21c6e2d527b1d15cea3c0c00c3efa2da179f2b1e17d5ba8f15342"
    sha256 catalina:       "3caf0d603f3f9160be0eb77991622c98d294759a3e70dd04d334636a39bd33cf"
    sha256 x86_64_linux:   "cb3754588e0c6b8da41f350de19e14305ac1b97051002b0e8ed0dd4c012e6715"
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
