class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  url "https://github.com/pocl/pocl/archive/refs/tags/v4.0.tar.gz"
  sha256 "7f4e8ab608b3191c2b21e3f13c193f1344b40aba7738f78762f7b88f45e8ce03"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a90c1e5f68eb284277ba8112db2fa25064afdbd16365cd3f6d7cc2fecf09eeed"
    sha256 arm64_monterey: "2db280955137c183b5c3ed82875cf71f941f4f8e5b7eb59df4b06ff09ce2f161"
    sha256 arm64_big_sur:  "5d43cb81906abbc0275cea2b574ae0845358ac08d1a94dbd2bcda22fda683983"
    sha256 ventura:        "9f1013f2b09ac98820dedc2f6efe0617a3a6420d64ffde99a7d6d1eaabc68bb9"
    sha256 monterey:       "0729e6e51172e48da279eedcc1f29c58009670c6dc116bd8a2ae9da78c0b9e73"
    sha256 big_sur:        "335a07a42d92cdaaa31ee4080a5fc6d75aa1ad7753c415f77728f5a1dd6f48e4"
    sha256 x86_64_linux:   "5e70b0936e4fc63367baca4f6071b7d77a1465ae51b8ed7776380c3499499cce"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm"
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
    llvm = Formula["llvm"]
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
