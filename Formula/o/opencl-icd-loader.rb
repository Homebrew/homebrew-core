class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2024.05.08.tar.gz"
  sha256 "eb2c9fde125ffc58f418d62ad83131ba686cccedcb390cc7e6bb81cc5ef2bd4f"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "246a54da1c0f660c7eebf00b9604a4f36b128c82467c18599f76d529d730102a"
    sha256 cellar: :any,                 arm64_sonoma:   "cd2503a44793a75faaa97c0e50e411eb5bb193ae46eb9322aea7a332a1b1e2bb"
    sha256 cellar: :any,                 arm64_ventura:  "23c2391187c581d54c6d342e02bdc852ec035a789a1775196363b059a31172a6"
    sha256 cellar: :any,                 arm64_monterey: "4faca16fca250c2dccbd146e72ac7710fad836633090c2ef9418e37bfd5a63ca"
    sha256 cellar: :any,                 sonoma:         "7b89c8f1ef6cbd4f9235247edaee7acfc3ff12634b410227b203139f68a987b7"
    sha256 cellar: :any,                 ventura:        "8ca1ef5cf133482540244be96d726edc64bce47af8cb5455748e00bf9b302005"
    sha256 cellar: :any,                 monterey:       "0c9ba10ff1fbda6e235e58ab191b2e4982e777a4627c92a2fff7c884182423c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b609a900ab18810a10b32fbc8e25a914131bf473ad614e0d639745130c3e6b78"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "opencl-headers" => [:build, :test]

  conflicts_with "ocl-icd", because: "both install `lib/libOpenCL.so` library"

  def install
    inreplace "loader/icd_platform.h", "\"/etc/", "\"#{etc}/"
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/loader_test"
    (pkgshare/"loader_test").install "test/inc/platform", "test/log/icd_test_log.c"
  end

  def caveats
    s = "The default vendors directory is #{etc}/OpenCL/vendors\n"
    on_linux do
      s += <<~EOS
        No OpenCL implementation is pre-installed, so all dependents will require either
        installing a compatible formula or creating an ".icd" file mapping to an externally
        installed implementation. Any ".icd" files copied or symlinked into
        `#{etc}/OpenCL/vendors` will automatically be detected by `opencl-icd-loader`.
        A portable OpenCL implementation is available via the `pocl` formula.
      EOS
    end
    s
  end

  test do
    cp_r (pkgshare/"loader_test").children, testpath
    system ENV.cc, *testpath.glob("*.c"), "-o", "icd_loader_test",
                   "-DCL_TARGET_OPENCL_VERSION=300",
                   "-I#{Formula["opencl-headers"].opt_include}", "-I#{testpath}",
                   "-L#{lib}", "-lOpenCL"
    assert_match "ERROR: App log and stub log differ.", shell_output("#{testpath}/icd_loader_test", 1)
  end
end
