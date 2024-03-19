class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.9.0/arrayfire-full-3.9.0.tar.bz2"
  sha256 "8356c52bf3b5243e28297f4b56822191355216f002f3e301d83c9310a4b22348"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "650969590a44f7c5d1d5000989953878a03e4549e18ca3a0321b376b1176a8cb"
    sha256 cellar: :any,                 arm64_monterey: "32b390606d4d6ab98777cfcc3881f9bb8da57a1fd6fecd1ba11808a618bbbb22"
    sha256 cellar: :any,                 arm64_big_sur:  "7e325b8e045a50b5f63cf19abddd117b6bcade0841747acb4ce4adb300467fdf"
    sha256 cellar: :any,                 ventura:        "dfcaf43eff1c00bb58a88cf6810e1ae62a32396463494bfbb7c2436399550b2a"
    sha256 cellar: :any,                 monterey:       "4255dcc58fe0924ec7e8259a40775f4d2a76a667d41f3a6a83189781ac54c540"
    sha256 cellar: :any,                 big_sur:        "e78ce63335d09e140f8a3f556226f08668eaaa96bb0d0679296f802094914692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d776a57f42864b0bddcd6826196b0ae10adf21f9619fee0496d5f91fd48440e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "fmt"
  depends_on "freeimage"
  depends_on "openblas"
  depends_on "spdlog"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

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
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove debug info. These files make patchelf fail.
    rm_f [
      lib/"libaf.debug",
      lib/"libafcpu.debug",
      lib/"libafopencl.debug",
    ]
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
