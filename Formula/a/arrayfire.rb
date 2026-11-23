class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.10.1/arrayfire-full-3.10.1.tar.bz2"
  sha256 "e8fca89c71e268ecd2ed392e46149b30e88c5aa8807ecfd45402e09de2bacb11"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    manifest_sha256 "0454abe377d78bb3934d57c4dfb388ab65378897024e4e6753b64ed4208aa841"
    sha256 cellar: :any, arm64_golden_gate: "106384a47dbb5001bc6c66c6522d88693ff94fbce9e301783ad917e1aed22737"
    sha256 cellar: :any, arm64_tahoe:       "9a2729d15de5726ee09f13c96b48fbd5629b5a8812924f92f90bfa3af9d372d8"
    sha256 cellar: :any, arm64_sequoia:     "6ab6651e61ddda0a26e43d05f7c608542fc5640758b93e69e7720d9220eb8371"
    sha256 cellar: :any, arm64_linux:       "4b53a4fecb9da11f52c2282aadfcc571cad27c8c3e2e047ff2df667981475dbc"
    sha256 cellar: :any, x86_64_linux:      "b73850f5a819dfbd11c245fb23d0ec4d4d5662dcd32f3699a6375eb87b3bebf6"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "opencl-clhpp-headers" => :build
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

  deny_network_access!

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: formula_opt_lib("fftw")),
      rpath(source: lib, target: formula_opt_lib("openblas")),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
    # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
    inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)" if OS.mac?

    # Building in-tree with the AF_INTERNAL_DOWNLOAD_FLAG so that CMake uses
    # the bundled extern/* sources and doesn't try running git when offline
    system "cmake", "-S", ".", "-B", ".",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_BUILD_EXAMPLES=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DAF_INTERNAL_DOWNLOAD_FLAG=ON",
                    "-DAF_WITH_EXTERNAL_PACKAGES_ONLY=ON",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_MKL=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

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
