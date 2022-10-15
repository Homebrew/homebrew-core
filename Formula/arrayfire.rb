class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.2/arrayfire-full-3.8.2.tar.bz2"
  sha256 "2d01b35adade2433078f57e2233844679aabfdb06a41e6992a6b27c65302d3fe"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "71be74a2fb4cfef401b9d30b4b989f29f55d2b7afad39fa14fd1d863f79b6135"
    sha256 cellar: :any,                 arm64_big_sur:  "eaa737937722fafe28aa5ac8f0a884b63a766ca9ad728f0ef0c1050c800c1713"
    sha256 cellar: :any,                 monterey:       "daf2e329c959d80f5af45ac61dfb17a97b8049bec82e99392a2bfd63c1c7973b"
    sha256 cellar: :any,                 big_sur:        "5daecc3594aa7aba3fe4fb2c412ca97573bdcaf4f2b47e5481f04fbdf63585bd"
    sha256 cellar: :any,                 catalina:       "a92f054d91e3aa6ec66a91fa35e54d11e69ef2067d106de074f27920403be209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a219bf51abf596d31369504a6f134903ff2f290e557857d73219da34606da29a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "freeimage"
  depends_on "openblas"

  fails_with gcc: "5"

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    # We cannot use `CMAKE_INSTALL_RPATH` since upstream override this:
    #   https://github.com/arrayfire/arrayfire/blob/590267d2/CMakeModules/InternalUtils.cmake#L181
    linker_flags = [
      rpath(source: lib, target: Formula["fftw"].opt_lib),
      rpath(source: lib, target: Formula["openblas"].opt_lib),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]
    linker_flags.map! { |path| "-Wl,-rpath,#{path}" }

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
