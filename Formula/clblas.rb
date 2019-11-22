class Clblas < Formula
  desc "Library containing BLAS functions written in OpenCL"
  homepage "https://github.com/clMathLibraries/clBLAS"
  url "https://github.com/clMathLibraries/clBLAS/archive/v2.12.tar.gz"
  sha256 "7269c7cb06a43c5e96772010eba032e6d54e72a3abff41f16d765a5e524297a9"

  bottle do
    cellar :any
    sha256 "97d7206bae700bdba2b4f1c6570d7e772ab5ade56d82af61d98d75eebe764f72" => :catalina
    sha256 "de18e1f78894ad83aa80a1d2a6d21973d61507be13a657055bd19b1f11b80c0b" => :mojave
    sha256 "47e08f87365e11a57d2ffc2fb81a3cfcd8bd784c438c1e08e1fe4116fc774553" => :high_sierra
    sha256 "22a6cc8252ed5d431ccea7d51631f57bcee3876be7f65a0ac0fbaabfe09a9484" => :sierra
    sha256 "e18aa93ecbd78f5f70607653a1e1c48f73952aeef1a568e2205362368c40ba4c" => :el_capitan
    sha256 "ac0d50729480e60afd56862a49f92408cb0ed61967ba91fcdc9e024e06f39917" => :yosemite
  end

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
