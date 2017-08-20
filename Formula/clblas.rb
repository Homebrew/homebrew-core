class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.12.tar.gz"
  sha256 "7269c7cb06a43c5e96772010eba032e6d54e72a3abff41f16d765a5e524297a9"

  depends_on "boost" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", "src", *std_cmake_args,
                    "-DBUILD_CLIENT=OFF",
                    "-DBUILD_KTEST=OFF",
                    "-DBUILD_TEST=OFF",
                    "-DCMAKE_MACOSX_RPATH:BOOL=ON",
                    "-DSUFFIX_LIB:STRING="
    system "make", "install"
    pkgshare.install "src/samples/example_srot.c"
  end

  test do
    # We do not run the test, as it fails on CI machines
    # ("clGetDeviceIDs() failed with -1")
    system ENV.cc, pkgshare/"example_srot.c", "-I#{include}", "-L#{lib}",
                   "-lclBLAS", "-framework", "OpenCL"
  end
end
