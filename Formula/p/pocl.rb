class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  license "MIT"
  revision 1

  stable do
    url "https://github.com/pocl/pocl/archive/refs/tags/v7.0.tar.gz"
    sha256 "f55caba8c3ce12bec7b683ce55104c7555e19457fc2ac72c6f035201e362be08"
    depends_on "llvm@20" # TODO: use `llvm` next release, https://github.com/pocl/pocl/pull/1982
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e39e3235300c89de9d68523fb5d25eab669f664ae0713760fa3f4bf94ee3c45c"
    sha256 arm64_sequoia: "ce20bf8e55006a7e27ee297c9ade37a0f1d764eca612addd932083eb05653379"
    sha256 arm64_sonoma:  "ad257d6295b26845ee36310ce3bd75a2dbc51d68c5f74fbea83e04715cf2a6ac"
    sha256 arm64_ventura: "99dd1eb71561ce4ab0877ea116f71b7fe6c1ff0d192c9e01220ca891dc584ba9"
    sha256 sonoma:        "c69a5c293303eb4674ae6e6a108bcf68b5a274e1d6a28c021dc6f781ea65bf7f"
    sha256 ventura:       "84be53db65680a555f1c1d2f4def745ed949c6c5dd8b4510680ccecaa1ce98b5"
    sha256 arm64_linux:   "4c2330ef849806b7ba65683d396f6cdd0bfae24c80ae2019b5f297d0ed19b8b4"
    sha256 x86_64_linux:  "6e31505d8843897ac4f6ad07cb75c3c67ff7d2d8617defdca9fc4015a41ca222"
  end

  head do
    url "https://github.com/pocl/pocl.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
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
