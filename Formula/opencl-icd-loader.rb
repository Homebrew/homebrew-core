class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2023.02.06.tar.gz"
  sha256 "f31a932b470c1e115d6a858b25c437172809b939953dc1cf20a3a15e8785d698"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef4b4ddf4ffe2965d782ea7bbc6ea16467f0dbfc8ea20f376c91a32456f0d914"
    sha256 cellar: :any,                 arm64_monterey: "addb20a0f656d8bb3e96a6fe4c51aaef87dcd646beacf7dfc42b60531453a29c"
    sha256 cellar: :any,                 arm64_big_sur:  "79efc87595a1567dc62b6fc9db6f5c98e260dbe59e7ba7f96cbb02c7fd9bbfc7"
    sha256 cellar: :any,                 ventura:        "fb3b1778f00b994cfc1867c41c471e7506f36da3f77bff0cc1db1df841396da9"
    sha256 cellar: :any,                 monterey:       "dcbb872e7a609aeac916ff8e6396249e3cb85af57973880e1527b9fafee35eb5"
    sha256 cellar: :any,                 big_sur:        "1646ea2eb71e83c0b915a10201cfa2fdfbddd8e0720227f7cfc0110694ed54e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534ec812897b7428a9964791c342b50b90e82de936d5e964436851fc125f050f"
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
