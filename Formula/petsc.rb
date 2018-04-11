class Petsc < Formula
  desc "Scalable solution of models that use partial differential equations"
  homepage "https://www.mcs.anl.gov/petsc/index.html"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.9.0.tar.gz"
  sha256 "a233e0d7f69c98504a1c3548162c6024f7797dde5556b83b0f98ce7326251ca1"

  depends_on "gcc"
  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  def install
    system "./configure", "CC=mpicc",
                          "CXX=mpicxx",
                          "F77=mpif77",
                          "FC=mpif90",
                          "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-shared-libraries=1",
                          "--with-ssl=0",
                          "--with-x=0",
                          "--with-hdf5-dir=#{Formula["hdf5"].opt_prefix}",
                          "--with-hwloc-dir=#{Formula["hwloc"].opt_prefix}",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-netcdf-dir=#{Formula["netcdf"].opt_prefix}",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
                          "--with-suitesparse-dir=#{Formula["suite-sparse"].opt_prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/examples/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc"
    output = shell_output("./a.out | grep 'Norm of error' | awk '{print $4}'")
    assert(output.to_f < 1.0e-13)
  end
end
