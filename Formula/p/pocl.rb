class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/pocl/pocl/archive/refs/tags/v4.0.tar.gz"
  sha256 "7f4e8ab608b3191c2b21e3f13c193f1344b40aba7738f78762f7b88f45e8ce03"
  license "MIT"
  revision 1
  head "https://github.com/pocl/pocl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "5e7b336b21a6ffde6aae6cbe3273f33ae6438b08909a093f0a34688e80801fa7"
    sha256 arm64_monterey: "153252a706f06d57bfae9c12d2de6ccaf4d19cffa24ce87394c626b5eda6a45c"
    sha256 arm64_big_sur:  "9f999bfbb69605c9a6d2314ce71f0d52eba3d68646326ed028492961dfc829b0"
    sha256 ventura:        "5817ff47185a49e4a2ce6ed69bf20ec67ac0b236b935a7896be9f822ce7f94a9"
    sha256 monterey:       "cd69d082c6bb811c7b31ab1c658848ecacf1d3ec2208b6bfe8810020699d4d79"
    sha256 big_sur:        "005ef88c339b74e8e18ef9d488f77f9e67450c109f2cdf059f19a2a80d00e54f"
    sha256 x86_64_linux:   "005d4f007bee115383c9e1de562cab2ac15379070513906a09ba2b957d2e4465"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm@16"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  fails_with :clang do
    cause <<-EOS
      .../pocl-3.1/lib/CL/devices/builtin_kernels.cc:24:10: error: expected expression
               {BIArg("char*", "input", READ_BUF),
               ^
    EOS
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = Formula["llvm@16"]
    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{loader_path};#{rpath(source: lib/"pocl")}
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DWITH_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      -DLLVM_PREFIX=#{llvm.opt_prefix}
      -DLLVM_BINDIR=#{llvm.opt_bin}
      -DLLVM_LIBDIR=#{llvm.opt_lib}
      -DLLVM_INCLUDEDIR=#{llvm.opt_include}
    ]
    # Avoid installing another copy of OpenCL headers on macOS
    args << "-DOPENCL_H=#{Formula["opencl-headers"].opt_include}/CL/opencl.h" if OS.mac?
    # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
    args << "-DKERNELLIB_HOST_CPU_VARIANTS=distro" if Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/poclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}/etc/OpenCL/vendors" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_predicate testpath/"poclcc.cl.pocl", :exist?
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_predicate include/"OpenCL", :exist?
  end
end
