class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2022.09.23.tar.gz"
  sha256 "937bbdb52819922e0e38ae765e3c3d76b63be185d62f25e256ea3f77fdaa9913"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a166392b2495da5feff5c20247699a065ec9923bd8239ad82ce58f9cc6667663"
    sha256 cellar: :any,                 arm64_big_sur:  "8e33044b098f04bd9e77371397f2aab65d90073e93449acd8d1f7dc53b767e6d"
    sha256 cellar: :any,                 monterey:       "f808d1255a4ad0ec72ec986e3b7e937cf66c6b09aaeb16704dec45a57950d18c"
    sha256 cellar: :any,                 big_sur:        "b922f399390e0129d1daf28722985fc985dc68aa47646732cd39238b1401611f"
    sha256 cellar: :any,                 catalina:       "e531ef20569d6803d8cd025d3bfa23f1c0eb1460f8b52604791586cbc4232924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b11018926460b23b2c4d5fc1055b6289d787f997ce86fe769d21d71ac18799e4"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "opencl-headers" => [:build, :test]

  def install
    inreplace "loader/icd_platform.h", "\"/etc/", "\"#{etc}/"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
