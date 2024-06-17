class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/pocl/pocl/archive/refs/tags/v5.0.tar.gz"
  sha256 "fd0bb6e50c2286278c11627b71177991519e1f7ab2576bd8d8742974db414549"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "5a08a39c3bfa061e5a1ad5a9f9ebe5a1bbcaef22c8d20c30bdb39312d451a705"
    sha256 arm64_ventura:  "f19ca534a463223a2ab95bfc75c3175b5b7150decb99029d4f851518d33ecee8"
    sha256 arm64_monterey: "0c7bf3c8a33798ecee79b13442b1ee9bcf80effb62296498df77442deb74635a"
    sha256 sonoma:         "21786e84c812f4eee22a02b020d6697c4c7bc89df2cddc0558cb9d87b37583ec"
    sha256 ventura:        "bcefb4087daf0a50ff4458d121c621046a930d383d4e9dd3ebcbedc0e726ef23"
    sha256 monterey:       "a54039226cb71efc1f3403eac8e1261e2414a13ecb4be988b1fbf8814b0bb342"
    sha256 x86_64_linux:   "ca2098402032e2725e2a0d842963eba33a87f66564e90acca3011d802cc9039d"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkg-config" => :build
  depends_on "hwloc"
  depends_on "llvm@16"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

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
