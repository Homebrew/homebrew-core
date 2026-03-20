class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.24.5.tar.gz"
  sha256 "b538efa53ebfa5c7a1c3ac9783a57852a74ce4fb436f0ee4802564503c67269f"
  license "BSD-2-Clause"

  livecheck do
    url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/"
    regex(/href=.*?petsc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cb63eda49bd5a639d9b121a83685f681503ecd2f9a8f0a6332fd0ec7c008b99f"
    sha256 arm64_sequoia: "d835d509ea8c459e3a835bba1a8b6946f8cdbfaa2629595df84a0bee7eaaae1c"
    sha256 arm64_sonoma:  "727d84824d2d022142208e22134fcb6aa21ee5d21b02d8fbec42a628f0b4f2f9"
    sha256 sonoma:        "668cc752e91bac885c76bb9d851557e5f5c39dcae7641e2f0c9b07266271e948"
    sha256 arm64_linux:   "9a62a02aeeb083562b80166510788fdc355c846b013cbcf31c055b390d5efe4a"
    sha256 x86_64_linux:  "278d9359f4233ea04ca4a47b1bcd5d8c75f877cb478b3f784b3104cca8b5ff79"
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
                          "--with-fftw-dir=#{Formula["fftw"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5-mpi"].opt_prefix}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
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
