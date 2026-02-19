class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  url "https://github.com/pocl/pocl/archive/refs/tags/v7.1.tar.gz"
  sha256 "1110057cb0736c74819ad65238655a03f7b93403a0ca60cdd8849082f515ca25"
  license "MIT"
  head "https://github.com/pocl/pocl.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "cc45a16ddaf37efac69ad995690efe2979143b304c20c30179581b04161cf6b4"
    sha256 arm64_sequoia: "03a539344b6f557b050cbda86913e9936cf7dfa3d157ee90e438b40eab16610d"
    sha256 arm64_sonoma:  "c1492bebca73399ccdbe9db343f5c9999f58ec2dab464cf9249b4b8f07b287d6"
    sha256 sonoma:        "ac55a8d49c48770e574446ff3ab95e023370059c0e954fe674103a7751fa9b27"
    sha256 arm64_linux:   "4c88564ba6f258b924e62ea47306847a1a2ed9356f6723de2273d4235dc959a2"
    sha256 x86_64_linux:  "b3fb64a5cd37f39d1e70240495f41a1d3e3b267911e50ed4a912b1da4edf162d"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
  depends_on "llvm"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    rpaths = [loader_path, rpath(source: lib/"pocl")]
    rpaths << llvm.opt_lib.to_s if OS.linux?
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DINSTALL_OPENCL_HEADERS=OFF
      -DWITH_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      -DLLVM_PREFIX=#{llvm.opt_prefix}
      -DLLVM_BINDIR=#{llvm.opt_bin}
      -DLLVM_LIBDIR=#{llvm.opt_lib}
      -DLLVM_INCLUDEDIR=#{llvm.opt_include}
    ]
    if build.bottle?
      args << if Hardware::CPU.intel?
        # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
        "-DKERNELLIB_HOST_CPU_VARIANTS=distro"
      elsif OS.mac?
        "-DLLC_HOST_CPU=apple-m1"
      else
        "-DLLC_HOST_CPU=generic"
      end
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/poclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}/etc/OpenCL/vendors" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_path_exists testpath/"poclcc.cl.pocl"
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_path_exists include/"OpenCL"
  end
end
