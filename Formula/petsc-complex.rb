class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.17.2.tar.gz"
  sha256 "2313dd1ca41bf0ace68671ea6f8d4abf90011ed899f5e1e08658d3f18478359d"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_monterey: "32a19faad2e79691dd2965e6e73641c7539c0a53580c59ce8a546ca4421ecbd5"
    sha256 arm64_big_sur:  "3d6c9c88cd259b6e56d4209bb9da39c9c5bb0882e3d77fc249c344151c5a134d"
    sha256 monterey:       "94225dae39db0a1a373a5b414314a74318b52649203d0917c2e20ad76cb4ecdb"
    sha256 big_sur:        "2886b474b543fa22648aebd30dd62b547fe3aff8116938a915896a0ee88fb7f6"
    sha256 catalina:       "03e8ebce2ec3afa112eba76d7bcbc8055c18a0a725eb73d762f9d20900353228"
    sha256 x86_64_linux:   "f7e3e2b2b8537d4c21d8a7a317c69e908fbe6c512036059f256209c5d72d98ca"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.10"
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
