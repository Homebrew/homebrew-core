class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  url "https://github.com/pocl/pocl/archive/refs/tags/v6.0.tar.gz"
  sha256 "de9710223fc1855f833dbbf42ea2681e06aa8ec0464f0201104dc80a74dfd1f2"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7b3835607078ca4df3dbc06854f76b5e549c50d4ed09bf3563492a2be94fd620"
    sha256 arm64_ventura:  "9448e2ec4c6f9759cf5acf4ff4d8b24c50b68851599c2e873097c5441f1f5d72"
    sha256 arm64_monterey: "2d090450167c159d1083b9df2ade36d85a0d17e362c0a13f8bf08b632a80efba"
    sha256 sonoma:         "bae9b3cdceb4f661361ca8b8e4a707b39e38486ae561fbd4afc5ec4a9a092586"
    sha256 ventura:        "22cc146f8f6755af636e50044bebd2a447c5d32c34081ddde727746ba678e128"
    sha256 monterey:       "4e5c6cd2e3605ebdc7a3425586dbdecb525e1e1279eb701460a7a3ce19b409f7"
    sha256 x86_64_linux:   "f2f04dd95cf7e74bc2a34094500c4850047365b41bc1ec206672c4e4a95a392e"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

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
