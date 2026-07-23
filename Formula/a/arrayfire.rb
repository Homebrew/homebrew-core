class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.10.0/arrayfire-full-3.10.0.tar.bz2"
  sha256 "74e14b92a3e5a3ed6b79b000c7625b6223400836ec2ba724c3b356282ea741b3"
  license "BSD-3-Clause"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "491e0b57991801e4470cb389008aa512ba573f3a16414f941acbb84ddadbccd2"
    sha256 cellar: :any, arm64_sequoia: "6ec8984f0c8834ae1a4ac40f02165a377104bbd5929091e4eb3ee389344d3e91"
    sha256 cellar: :any, arm64_sonoma:  "6dbb89aaccaa450eb89e6d4010c08d0ea1fe7827e07e6e7b310908b0c2218acd"
    sha256 cellar: :any, sonoma:        "2dcd335dff6f106f88134c5a78c3a4b270a41655c388a7b02e02bb288bf21411"
    sha256 cellar: :any, arm64_linux:   "06de859182ea4dfb7fae6c1857db3f79e583868d00408eb49e504e58bf9cf268"
    sha256 cellar: :any, x86_64_linux:  "9b171c8bcf60aafee70410fe13bb3968092b4010373958d533d57f071d6478bb"
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
    ENV.method(DevelopmentTools.default_compiler).call if OS.linux?
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end
