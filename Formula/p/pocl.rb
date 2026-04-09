class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  # TODO: Use LLVM 22 on next release
  url "https://github.com/pocl/pocl/archive/refs/tags/v7.1.tar.gz"
  sha256 "1110057cb0736c74819ad65238655a03f7b93403a0ca60cdd8849082f515ca25"
  license "MIT"
  revision 1
  head "https://github.com/pocl/pocl.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bb711ac8b9f001246637a341af5aa351a3a05cb54e189537e851946c723acb9a"
    sha256 arm64_sequoia: "4986925f9eb442e6cbab412da2d48f6362baa9c194df0d46ab51a49c702e75f3"
    sha256 arm64_sonoma:  "f97dd2a38b4527337ccdcf7c7f6935775ff05d777bab6af37e0417680ac1f53f"
    sha256 sonoma:        "700d6876251438d70c9f3202ab104cb02dca09e510ca66f92ae8f704f4dcc448"
    sha256 arm64_linux:   "edc29649f782e47466b12f5195be6eb6baace8b041c87676b256c88d442f7ce7"
    sha256 x86_64_linux:  "5f0004f051b01482186efaeb3d7cc9323aa6bb67c29c113be3c3d4b5da2cf0ea"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
  depends_on "llvm@21"
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
