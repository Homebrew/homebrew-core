class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "http://portablecl.org/downloads/pocl-3.1.tar.gz"
  sha256 "82314362552e050aff417318dd623b18cf0f1d0f84f92d10a7e3750dd12d3a9a"
  license "MIT"
  revision 2
  head "https://github.com/pocl/pocl.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a889cde4e1f855f90ccc3e9afcb0839c3f2cd63ac4788c3b6ae109fdf69e3b01"
    sha256 arm64_monterey: "b102e21ee22fb6da243b672735d26d75aacceb79cb2628d5cb6897dc7709423d"
    sha256 arm64_big_sur:  "05ad886415b8c78098aec4a5511e058b86e5c4b90833e815f4f010b47723d258"
    sha256 ventura:        "31547dd88a441097ac30b5a396d293af17331df64223e5d6bc75e8bee5219c70"
    sha256 monterey:       "ebd4512a7dffd600b8a02b61fa017fe5f90c8b693785963d241dffcb224bd703"
    sha256 big_sur:        "be751028d7efa9dd39564b3a79e39a40aaa6916683cccabde37b030884a64b10"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm@15"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build # because of `fails_with :clang`
  end

  fails_with :clang do
    cause <<-EOS
      .../pocl-3.1/lib/CL/devices/builtin_kernels.cc:24:10: error: expected expression
               {BIArg("char*", "input", READ_BUF),
               ^
    EOS
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    ENV.llvm_clang if OS.mac?
    llvm = deps.reject(&:build?).map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Make sure our runtime LLVM dependency is found first.
    ENV.prepend_path "PATH", llvm.opt_bin
    ENV.prepend_path "CMAKE_PREFIX_PATH", llvm.opt_prefix

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
