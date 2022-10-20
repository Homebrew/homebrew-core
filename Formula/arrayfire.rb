class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.2/arrayfire-full-3.8.2.tar.bz2"
  sha256 "2d01b35adade2433078f57e2233844679aabfdb06a41e6992a6b27c65302d3fe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cdcb0b0c204907ca8e6fd03438cdb5ced7596edac21e91c61c4230c762b7abe8"
    sha256 cellar: :any,                 arm64_big_sur:  "b64a38b084b3aacbc05b5cd0a047d2db3d105c6ee0daabd98154687d5b7b5ed1"
    sha256 cellar: :any,                 monterey:       "14baef69a6ab743f9c77d4be0626b61381e321efb19a5c8fdc50108b4ce8f432"
    sha256 cellar: :any,                 big_sur:        "d1e74ce111fe56acca627edaedde4e64831f3b9541c663d98d741ff18429413c"
    sha256 cellar: :any,                 catalina:       "0bb39b21995aa1c327d52be9dcb259523977b318e79e6ee984e50aca54f01c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9291a3d4728f18c57f9f5beadeedf526e0963f7d0cc09fa1110d66a91b05c9d"
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
