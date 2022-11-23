class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.12.tar.gz"
  sha256 "7269c7cb06a43c5e96772010eba032e6d54e72a3abff41f16d765a5e524297a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "51bf7beb98613de62fd3490a19917322d29cb6b44a99d7bf4618f7812b5b151c"
    sha256 cellar: :any,                 arm64_monterey: "05f10b95b407296d687e06648a0c4abaa7d590ede330b687ac7874d8afbbe863"
    sha256 cellar: :any,                 arm64_big_sur:  "f0292a882d4f60d4e59ed42e1c41f063b90a2dcecdfb24cc8757f9f216eaf935"
    sha256 cellar: :any,                 ventura:        "b299072f25927a5664c4fa67dc4547786fdff9c7239b27aa31d205959a0caa84"
    sha256 cellar: :any,                 monterey:       "bcf26f9fa5be8cee77f022a7364119e73281dc8bd18451ddf3c7b98fbf8513ad"
    sha256 cellar: :any,                 big_sur:        "e68a3ce1669b5f88aa5ca31e57ccb687f99601d35f3fcf7470de8e38d53671c9"
    sha256 cellar: :any,                 catalina:       "97d7206bae700bdba2b4f1c6570d7e772ab5ade56d82af61d98d75eebe764f72"
    sha256 cellar: :any,                 mojave:         "de18e1f78894ad83aa80a1d2a6d21973d61507be13a657055bd19b1f11b80c0b"
    sha256 cellar: :any,                 high_sierra:    "47e08f87365e11a57d2ffc2fb81a3cfcd8bd784c438c1e08e1fe4116fc774553"
    sha256 cellar: :any,                 sierra:         "22a6cc8252ed5d431ccea7d51631f57bcee3876be7f65a0ac0fbaabfe09a9484"
    sha256 cellar: :any,                 el_capitan:     "e18aa93ecbd78f5f70607653a1e1c48f73952aeef1a568e2205362368c40ba4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bf323af5a469bbf9dfc587bf029621dd292b20369315b1b8b5a98feaf1f0d2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "opencl-headers" => [:build, :test]
    depends_on "ocl-icd"
    depends_on "pocl"
  end

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
    opencl_lib = OS.mac? ? ["-framework", "OpenCL"] : ["-lOpenCL"]
    system ENV.cc, pkgshare/"example_srot.c", "-I#{include}", "-L#{lib}",
                   "-lclBLAS", *opencl_lib, "-Wno-implicit-function-declaration"
  end
end
