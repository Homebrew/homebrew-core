class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.3/arrayfire-full-3.8.3.tar.bz2"
  sha256 "331e28f133d39bc4bdbc531db400ba5d9834ed2d41578a0b8e68b73ee4ee423c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "695ade6b6f60c3ca0fd664c473b5739741986954cdd8df4e981d8eef331b3b85"
    sha256 cellar: :any,                 arm64_big_sur:  "7c5141c82083935c882f942bfd6ccbab6b9ead0983d0e212c60c7b92fd47e8d2"
    sha256 cellar: :any,                 ventura:        "0dbf7247ae4f2b26c2dc02d6a301d809bc391f498c7610cccfe9bce5a1a31630"
    sha256 cellar: :any,                 monterey:       "e3c760e73a4cb3c16b1e650b88d38b86b1c3ec7629a4836eac97322f31df2655"
    sha256 cellar: :any,                 big_sur:        "b31c396d025c4a964a8f551545a39d69da4a1c666e7234482249aac23c3bdd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5116d16d7eae5bd1e4752550445d8a8b522c794cb5c2977f871074409768c7ca"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "fmt"
  depends_on "freeimage"
  depends_on "openblas"
  depends_on "spdlog"

  fails_with gcc: "5"

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: Formula["fftw"].opt_lib),
      rpath(source: lib, target: Formula["openblas"].opt_lib),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
    # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
    inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
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
