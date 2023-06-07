class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.8.3/arrayfire-full-3.8.3.tar.bz2"
  sha256 "331e28f133d39bc4bdbc531db400ba5d9834ed2d41578a0b8e68b73ee4ee423c"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09c3e828667c6c77ee1bc5748d74f7e26d232f4349c7057366bb759d10164d63"
    sha256 cellar: :any,                 arm64_monterey: "0ff7909804cbe64288d0a478a3e475692ea1f4ee00983723ad388340f9391585"
    sha256 cellar: :any,                 arm64_big_sur:  "679a191a56b7efd653a8c101cc2ea8c991fd4b0eee2cf9b717dd5166750506b1"
    sha256 cellar: :any,                 ventura:        "5fb30d5630b12a8e027b109b31ac604c59b8ecae516dd2004eb83576262da634"
    sha256 cellar: :any,                 monterey:       "578e06b99afa0250508644cd512812c58f616accc5b5463c992941cd01a7b4ba"
    sha256 cellar: :any,                 big_sur:        "359e69062d6d0935a27fec1e5d4e8897477b1c4196563950a7c65094a9f0b327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85ca89a8bcf93aec2384ac0b52c96732eea96a96c878388a0b11d04eb39fa32d"
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
