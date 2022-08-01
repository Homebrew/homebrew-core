class Pocl < Formula
  desc "Portable Computing Language"
  homepage "http://portablecl.org"
  url "http://portablecl.org/downloads/pocl-3.0.tar.gz"
  sha256 "a3fd3889ef7854b90b8e4c7899c5de48b7494bf770e39fba5ad268a5cbcc719d"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "395e9e22eb5bd6cad1249365e9bdca3cf3624bdaf5d38d68b65170689c2b3812"
    sha256 arm64_big_sur:  "a90b4daf3ceddb1303a2edaf9c591664cdca5ae3675bab990819bac31634c7cb"
    sha256 monterey:       "1ed373e8a3a339b256f7342a8aa9b0553ea10d5a554c64f378d0fe5b8d7bd6b7"
    sha256 big_sur:        "845865a2883222703e17ab3e4a8df75da21c835e42251eae8800f1dd37e7ee5d"
    sha256 catalina:       "7f3f21085539e521ec9630a006bcd21c32dae5c119d1e910e6326856c1b23bc2"
    sha256 x86_64_linux:   "79b71049a56f46d3d00b3d3cb66c51ea1ade450c465ea8d0cfccf38a23a80e2d"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm"
  depends_on "ocl-icd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{lib};#{lib}/pocl
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DLLVM_BINDIR=#{Formula["llvm"].opt_bin}
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
