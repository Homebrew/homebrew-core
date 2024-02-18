class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.4.tar.gz"
  sha256 "b0d03a5595ee0a5696dd6683321e1dbfe9fea85238d3016a847b3d0bcdcfb3d9"
  license "BSD-2-Clause"

  livecheck do
    url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "04976d3442c247c7e54467df7fccbfb7d22156b53708ca223f667f64b68d8a37"
    sha256 arm64_ventura:  "19697ce5a66cc356542bbde4d08e7c6119aa5c4fcb5ccb57452dc930a969f00f"
    sha256 arm64_monterey: "be5ba3fded3d5d6dd4706f77942515eb8909c339fefe20f01eb4d302417a77a4"
    sha256 sonoma:         "a72498944f0fdec93f64a34a009b2755d7356b535e6a19c6e1e6592e14fbdcc5"
    sha256 ventura:        "a6527e1c0ff9a0ab02b0f4b10cf84cfb7dc16f3a1bcd09626151933fc6bb024d"
    sha256 monterey:       "24b63fdb52a7924eb071c8161bf26fd67fe598217c7818a8f2e6c72064dd95a8"
    sha256 x86_64_linux:   "1f219408d1f7a6d9dc8704ec1c5ce482a75b2eaa4931b6596fca5492d240794b"
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
