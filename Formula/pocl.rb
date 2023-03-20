class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  url "http://portablecl.org/downloads/pocl-3.1.tar.gz"
  sha256 "82314362552e050aff417318dd623b18cf0f1d0f84f92d10a7e3750dd12d3a9a"
  license "MIT"
  revision 1
  head "https://github.com/pocl/pocl.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "4b2eb686484b8f44b0f14ed8ff3126d100ecca595e931f6cf7848f79af01ce0b"
    sha256 arm64_monterey: "a585cf0ab10943ba6b1371fe91411dd6d6f60e9972495f8befff33b5689a8323"
    sha256 arm64_big_sur:  "7f8ccb845709dd1df204500e14770b0a2debc30ea6d81a982fd0a2ea661d5667"
    sha256 ventura:        "758084ccac11c736aa33b832cf95edd170117334468dfabc34d354bce79b959c"
    sha256 monterey:       "da53b30483848934bb6be33405e7c41b515c404d798ccecf3ec40ea86a45facd"
    sha256 big_sur:        "e64b4bbd980a70107064ad17f4f05a4a2236d224a54503c87674ba2dad310635"
    sha256 x86_64_linux:   "20a9e232705a2ea7315135c6bcc111d767128916ad2904de559f08eb580753d5"
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
