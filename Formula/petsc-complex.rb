class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.2.tar.gz"
  sha256 "4e055f92f3d5123d415f6f3ccf5ede9989f16d9e1f71cc7998ad244a3d3562f4"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "67ed50c4f0660780349b139c32e469027418b5ff6395d53aa631b72e9ef29b09"
    sha256 arm64_monterey: "7b989d35bdf7e533ad7e2b0500f26c2514187b4bce6bf63e27998eb81d22ccef"
    sha256 arm64_big_sur:  "b9f11138a58f7ded905e12693e280afff24b2a167018638ad047153143ceeb7a"
    sha256 ventura:        "59c81939d34c480cb97a0af0c631c210ac5d1894f6e49fce3756dae4aa69cd74"
    sha256 monterey:       "6c5b974116ac79ca5a97d418dd3d515d661811040d2a82f0aae1a178338498db"
    sha256 big_sur:        "3b5e8ab261e0813893402157a2ebd784b0548c9bce21885942655724ca544cdb"
    sha256 x86_64_linux:   "705e20464d1a83b510b43ed16a134c9e855b4e8d247c21a2af500ab6fba48ee3"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
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
