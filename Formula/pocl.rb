class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  url "http://portablecl.org/downloads/pocl-3.1.tar.gz"
  sha256 "82314362552e050aff417318dd623b18cf0f1d0f84f92d10a7e3750dd12d3a9a"
  license "MIT"
  revision 1
  head "https://github.com/pocl/pocl.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "725592ecff117e6a5fc79f7320b1594a0ed47381bc7f10c07b692234404bff82"
    sha256 arm64_monterey: "43648343bca02bc500617b33ef273b8f09f0f948ba162f09b7d03e2a5681506a"
    sha256 arm64_big_sur:  "fabea7901cd3581c85a191ecaeba1455e0a472131ed71661ed7b89a0b2b37a7b"
    sha256 ventura:        "27e4bfb8cc2b3449d7597c47dcfb6aa55a788a5ccaf9c9b076cb67ba5335ba17"
    sha256 monterey:       "a4b106c0bd8f0b96fd87ea1bd80370c0808266aee56d2113c1f8317ed6691c0a"
    sha256 big_sur:        "74dc0ea7f41310782790ed1a9e6432f4c361a72b91e14eca5a5adbed41ea47b5"
    sha256 x86_64_linux:   "76eb5a19e08571701d59405ad080ccefb35bb671f96200a7084bd771918ee304"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm"
  depends_on "opencl-icd-loader"

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
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}/etc/OpenCL/vendors" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_predicate testpath/"poclcc.cl.pocl", :exist?
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_predicate include/"OpenCL", :exist?
  end
end
