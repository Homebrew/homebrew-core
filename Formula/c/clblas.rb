class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/refs/tags/v2.12.tar.gz"
  sha256 "7269c7cb06a43c5e96772010eba032e6d54e72a3abff41f16d765a5e524297a9"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ddd0d6b3d160284e87fee5d6cbb6585632cd24842c1f26954205acb665e3c74a"
    sha256 cellar: :any,                 arm64_monterey: "ec2838495fac090d05c5eb2e2f5cb8fd3640bb238fc068459900e50cc7f28674"
    sha256 cellar: :any,                 arm64_big_sur:  "8ade8c33c4231863fb5ebda26cd90cd1e1b5f30193c9b7bb113939e2c588c9e9"
    sha256 cellar: :any,                 sonoma:         "07b22046dd5a9005ac31e41f688afd50aea6284d716ec67ab304d587d0f40f9e"
    sha256 cellar: :any,                 ventura:        "d8bc99eb36031d7e6f662b40b2d8ef98a1d60fe414959c2ec5f23c590ebcf353"
    sha256 cellar: :any,                 monterey:       "2be6e0730bf2740496eb4b90b90077ce65185ab8fc1c0714edb8ea834904a8ec"
    sha256 cellar: :any,                 big_sur:        "3f4f8ceae96d4b24049e7b81e89f7bc5785bcd7968bf5378fb54cafd259b6d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc8e13fe7b5d465840eac248a461975d7fd33b89ba74a238cb743c1ac6c7c1f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # Fix missing stdlib.h includes.
  # PR ref: https://github.com/clMathLibraries/clBLAS/pull/360
  patch do
    url "https://github.com/clMathLibraries/clBLAS/commit/68ce5f0b824d7cf9d71b09bb235cf219defcc7b4.patch?full_index=1"
    sha256 "df5dc87e9ae543a043608cf790d01b985627b5b6355356c860cfd45a47ba2c36"
  end

  def install
    system "cmake", "src", *std_cmake_args,
                    "-DBUILD_CLIENT=OFF",
                    "-DBUILD_KTEST=OFF",
                    "-DBUILD_TEST=OFF",
                    "-DCMAKE_MACOSX_RPATH:BOOL=ON",
                    "-DPYTHON_EXECUTABLE=#{which("python3") || which("python")}",
                    "-DSUFFIX_LIB:STRING="
    system "make", "install"
    pkgshare.install "src/samples/example_srot.c"
  end

  test do
    # We do not run the test, as it fails on CI machines
    # ("clGetDeviceIDs() failed with -1")
    opencl_lib = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"example_srot.c", "-I#{include}", "-L#{lib}",
                   "-lclBLAS", *opencl_lib, "-Wno-implicit-function-declaration"
  end
end
