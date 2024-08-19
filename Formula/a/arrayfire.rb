class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.9.0/arrayfire-full-3.9.0.tar.bz2"
  sha256 "8356c52bf3b5243e28297f4b56822191355216f002f3e301d83c9310a4b22348"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "299f14fef2c6fde1e37418dc89b69fdab58cdd64f94e1f4e6224a86e390c41b2"
    sha256 cellar: :any,                 arm64_ventura:  "14f1b6f1fe2c8c442c1f2ad3f75a1f9b7a252a123171c9ca63192f0f18636453"
    sha256 cellar: :any,                 arm64_monterey: "290feb9f740d79b69960f7a436b28f926acd44b57813621707a63f7931e65885"
    sha256 cellar: :any,                 sonoma:         "013b97c42f5856df55fd820fd0b60618f6d499805ec0c521ff831393e68d2809"
    sha256 cellar: :any,                 ventura:        "b179ae4ac1dc38da16c080993d5d970e7909a6cfdae15f93343982b78b6c8be6"
    sha256 cellar: :any,                 monterey:       "c2b3fbc6c5e70354dd25a8c242d1f2c163ca596d72f62a6b338d0807d63badbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4635b6a5294fdd22f1de00d06eaf228ff4c9d0f400b428a9f025573dc7adb95c"
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

    if OS.mac?
      # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
      # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
      inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)"
    else
      # Work around missing include for climits header
      # Issue ref: https://github.com/arrayfire/arrayfire/issues/3543
      ENV.append "CXXFLAGS", "-include climits"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DCMAKE_CXX_STANDARD=14",
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
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
