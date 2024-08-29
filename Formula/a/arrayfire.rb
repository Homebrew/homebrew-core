class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.9.0/arrayfire-full-3.9.0.tar.bz2"
  sha256 "8356c52bf3b5243e28297f4b56822191355216f002f3e301d83c9310a4b22348"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "aef59074ff5628ef41c629de9af481140971fb67d0dd952cf2624ad6add73f70"
    sha256 cellar: :any, arm64_ventura:  "e206b29e0790322ed14a06082e80a4ab2b804c79e3a98db0a134e71aa5f74ebe"
    sha256 cellar: :any, arm64_monterey: "2e1b6dcef1a94a00aface53d21cb5ded7977d9f9f9db74606250f47f82ec6f59"
    sha256 cellar: :any, sonoma:         "0347b552c78ae2da175819625d20bdc8de8cba7b6eb800f713a43b1690dbe3bd"
    sha256 cellar: :any, ventura:        "f0e961ea63dc30a6b72b23afcbd9181d94d43c7a24c0f75d9add33cb9420ffdd"
    sha256 cellar: :any, monterey:       "e0cdfa9839ea984d846c2fd7c9df45c337ae7159d07a590256896b1934d9670e"
  end

  depends_on "boost@1.85" => :build
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
