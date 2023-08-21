class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.3/arrayfire-full-3.8.3.tar.bz2"
  sha256 "331e28f133d39bc4bdbc531db400ba5d9834ed2d41578a0b8e68b73ee4ee423c"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e916ffb9494f4ae60b3175ab5f0fbdbb28692e1c089717231c92b889a36a8ae8"
    sha256 cellar: :any,                 arm64_monterey: "34f2ce47650347432d1450987136ea6cb1422ecd38d37ae069cbc2740083f757"
    sha256 cellar: :any,                 arm64_big_sur:  "b6608aeabf74e797ea20f252c0d628ddd5ceaba521007e334fe6a48c0d64a36b"
    sha256 cellar: :any,                 ventura:        "e5403a4ce6bc13591df9f4ce264a1d371ef07f55f4f8e8010c16d239b2781f68"
    sha256 cellar: :any,                 monterey:       "9d7acf295cf98c0a83b5bcd20f52b751061e190a493c14395953d1fe581d7681"
    sha256 cellar: :any,                 big_sur:        "f915f6c9b0bfd74bfc4439540da386a4ecb2c7689d365bbf400b4baf33b4bf4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ee45b0496f607d95fed9d002eb4b8a5a0e544bf1a7fa661dd8434c42829920"
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
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
