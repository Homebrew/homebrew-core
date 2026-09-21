class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.25.5.tar.gz"
  sha256 "6d61c472db39006d261542d1a42f1fa6c52d6e89f9e77041386189aa8c24b490"
  license "BSD-2-Clause"
  compatibility_version 2

  livecheck do
    url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/"
    regex(/href=.*?petsc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4a2cfca740f3178d270dde8c21d65b7f38f739e89e93af21f3f7e9b6e7f18cf7"
    sha256 arm64_tahoe:       "2eadc5e5cc9f673c3b92b9e9c501c721f23a35cb732c77406457228f8558ab91"
    sha256 arm64_sequoia:     "462817a9835ed8d437e4b3ea2d2c85a03f5801409c3b935cf360c3172b76b249"
    sha256 arm64_sonoma:      "cc24d5b28967c26192170fea71b0837fdca35329488e3cb452cb86f8a93eb30e"
    sha256 arm64_linux:       "24fd12da9daabcbe19aa821c4cd53808b82eb7a3a79e45acf274c068ba2f20c2"
    sha256 x86_64_linux:      "b393216dd349f86ea2435c2f19fd4213df49ba3b8d15f14e457298f48b912214"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "hwloc"
  depends_on "metis"
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
                          "--with-fftw-dir=#{formula_opt_prefix("fftw")}",
                          "--with-hdf5-dir=#{formula_opt_prefix("hdf5-mpi")}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{formula_opt_prefix("metis")}",
                          "--with-scalapack-dir=#{formula_opt_prefix("scalapack")}",
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
