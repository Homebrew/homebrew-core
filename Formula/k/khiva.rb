class Khiva < Formula
  desc "Algorithms to analyse time series"
  homepage "https://khiva.readthedocs.io/"
  url "https://github.com/shapelets/khiva.git",
      tag:      "v0.5.0",
      revision: "c2c72474f98ce3547cbde5f934deabb1b4eda1c9"
  license "MPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "79129c3668a37ad0c60c3225717337bd43e5bd453d8ada10ca36edc3eb0a6efd"
    sha256 cellar: :any,                 arm64_monterey: "520d5879468b0454190fce7fa890fb98cc169c917c0f72975fd97e5d2a5f1a77"
    sha256 cellar: :any,                 arm64_big_sur:  "9ff14629f60e6ed2f278774c30ed9348d3965e8bfbe90cc31ea605bf475c747a"
    sha256 cellar: :any,                 ventura:        "c3eefd4690eadad3ec6286d3ae1a95d354ed008612ffabbbbfcd82a1970794c4"
    sha256 cellar: :any,                 monterey:       "3c3fc743e58f62b1355ac3e942e1141cbf09b56de5e3516f522432c2de841491"
    sha256 cellar: :any,                 big_sur:        "9341225ecc460b464de3760bd654165199b598e6393bd2b92ffd24a6cdc0f7b6"
    sha256 cellar: :any,                 catalina:       "798a2bd7f9071245ce4c0b7c6058ade9f815e071e549ef07145cffbe59d2dc40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6a2fad78cda325494014e7c43de7175b2e4859a4fdf4410febd7415e30f7e2"
  end

  # Not compatible with newer `arrayfire` 3.9.0+ after changes in
  # https://github.com/arrayfire/arrayfire/commit/be7f2d93de3796050e56037cc0c340a2ef34e813
  # Last release on 2020-04-29 and last commit on 2020-05-20.
  deprecate! date: "2024-09-27", because: :does_not_build
  disable! date: "2025-09-27", because: :does_not_build

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "arrayfire"
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DKHIVA_USE_CONAN=OFF",
                    "-DKHIVA_BUILD_TESTS=OFF",
                    "-DKHIVA_BUILD_BENCHMARKS=OFF",
                    "-DKHIVA_BUILD_JNI_BINDINGS=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/matrixExample.cpp", testpath
    system ENV.cxx, "-std=c++11", "matrixExample.cpp",
                    "-L#{Formula["arrayfire"].opt_lib}", "-laf",
                    "-L#{lib}", "-lkhiva",
                    "-o", "test"
    # OpenCL does not work on ephemeral ARM CI.
    return if Hardware::CPU.arm? && OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "./test"
  end
end
