class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.5.tar.gz"
  sha256 "fb4e637758737af910b05f30a785245633916cd0a929b7b6447ad1028da4ea5a"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "bc09c6427ccb9f99252076372f9b24a15252029d09056b1b0c2dd08c5ca03a69"
    sha256 arm64_ventura:  "0700d4aec00f7f9abbe7324bc43610e1979df9431b9dd73d8f81fba6f0036591"
    sha256 arm64_monterey: "55e2a84ea78e6fd961924767f4a303606e105a8fb119513c0b5d9b3d2f7349cf"
    sha256 sonoma:         "fbc6d5293faacfcaa8b8c839a3fe0bb366032b062826dbf08da21d1d6eb0405f"
    sha256 ventura:        "d7ac8c3ad58e4aec4007eef8b8fcf80f83fb2eec8092e15aaa9b85b64a186a2b"
    sha256 monterey:       "e80a3494258cfd6e806bc41486603caf00563fa19c659202bedd3f5d78da1ed2"
    sha256 x86_64_linux:   "88b9f2b79b8a1df0e82002356c021bd3ac12a47d6a5e00d3d3bc848011905677"
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
