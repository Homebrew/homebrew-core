class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  url "http://portablecl.org/downloads/pocl-3.0.tar.gz"
  sha256 "a3fd3889ef7854b90b8e4c7899c5de48b7494bf770e39fba5ad268a5cbcc719d"
  license "MIT"
  revision 1
  head "https://github.com/pocl/pocl.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "763c6c34815b02cb72f021f36a46203cf64be5d5910021a608c64e2be1e725a5"
    sha256 arm64_monterey: "9d91bc69819fd1a381a63726b9caed1c78cfce71d0e81a246a5d6b374db19f59"
    sha256 arm64_big_sur:  "99ab32bd6ad08f28cfdbd745cdfe057487bdacff01d7d7d1ad176c4230b21636"
    sha256 ventura:        "66cf3d6626954b9517443e1f05b36bcf448db519e7465bb21c6d342f017f1875"
    sha256 monterey:       "d857f7ebdf4d88658b79a34a2d71902b846ad421ce17be610d7f4ad5c4725e80"
    sha256 big_sur:        "59b68f66eb1be4b844b161e59690d3dc6ccc65f6f91b34efa407014b2cd462ae"
    sha256 catalina:       "9f63be32517ad9e49c8e00b2f664a44b5948263f703d086c9592c48b1374c3ad"
    sha256 x86_64_linux:   "b784316a19030d4d04ffc96bdae8f018e2458731f3a5d71af261693943e571b9"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm@14"
  depends_on "ocl-icd"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{lib};#{lib}/pocl
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DLLVM_BINDIR=#{llvm.opt_bin}
    ]
    # Avoid installing another copy of OpenCL headers on macOS
    args << "-DOPENCL_H=#{Formula["opencl-headers"].opt_include}/CL/opencl.h" if OS.mac?
    # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
    args << "-DKERNELLIB_HOST_CPU_VARIANTS=distro" if Hardware::CPU.intel?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/poclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "pocl.icd" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_predicate testpath/"poclcc.cl.pocl", :exist?
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_predicate include/"OpenCL", :exist?
  end
end
