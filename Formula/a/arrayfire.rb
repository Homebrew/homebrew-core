class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.10.1/arrayfire-full-3.10.1.tar.bz2"
  sha256 "e8fca89c71e268ecd2ed392e46149b30e88c5aa8807ecfd45402e09de2bacb11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f224b64d47f6a67dd6dfc596a6e5097dc91b86a39a233a103179caa8f15f618"
    sha256 cellar: :any, arm64_tahoe:       "b59778bb395f7b1ecf8f4f3da7b66b54da788e549f1d8353af963e5660fc2114"
    sha256 cellar: :any, arm64_sequoia:     "ffdb9f6796dc072b80c34c66eb2221f8b7d371a7934a0865f7ba18e853b89093"
    sha256 cellar: :any, arm64_linux:       "62b8e874be2295a388507f60375bfc5b293aeb9fab53a5861afff5ca64288a30"
    sha256 cellar: :any, x86_64_linux:      "f5b10075024a7389b812798f3be6edcfaed9eadd07ea5f477d16892c072fdad9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "clblast"
  depends_on "fftw"
  depends_on "fmt"
  depends_on "openblas"
  depends_on "spdlog"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  fails_with :gcc do
    cause <<~CAUSE
      Building with GCC and CMake CXX_EXTENSIONS disabled causes OpenCL headers
      to not expose cl_image_desc.mem_object which is needed by Boost.Compute.
    CAUSE
  end

  # fmt 11 compatibility
  patch do
    file "Patches/arrayfire/fmt-11.patch"
    type :unofficial
    resolves "https://github.com/arrayfire/arrayfire/issues/3596"
  end

  # Fix ambiguous `std::abs` call rejected by newer libc++ (macOS 26 SDK)
  patch do
    url "https://github.com/arrayfire/arrayfire/commit/a19abf55660c63f21fdb1f9c24d03e857def2446.patch?full_index=1"
    sha256 "6cef40ccb4bad3c4224f193c46990190643f00ee7e9b0befc3b0fd9b95154820"
    type :unofficial
    resolves "https://github.com/arrayfire/arrayfire/pull/3710"
  end

  def install
    # FreeImage has multiple CVEs (https://github.com/arrayfire/arrayfire/issues/3547) and
    # has been dropped by distros like Arch Linux (https://archlinux.org/todo/drop-freeimage/).
    odie "FreeImage should not be a dependency!" if deps.map(&:name).include?("freeimage")

    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: formula_opt_lib("fftw")),
      rpath(source: lib, target: formula_opt_lib("openblas")),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
    # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
    inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DAF_WITH_EXTERNAL_PACKAGES_ONLY=ON",
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
