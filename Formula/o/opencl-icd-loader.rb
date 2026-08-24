class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2026.05.29.tar.gz"
  sha256 "48fd0c5181db7cd046f4f731d5955694892e10998d49d09ee0d997e7e04fd939"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d2a4ed934a51e67d4493ed4374899cd31364226da96ef2f3536617e3ef02c5e"
    sha256 cellar: :any, arm64_sequoia: "ea1f4e95d01b5d33fea1cc5f684d0ec5665541b1f4516c9b757f748487bc0747"
    sha256 cellar: :any, arm64_sonoma:  "2625c3a431893fef61d01e9c257ff948cf6e9e9edf4e29ad848a42f4e50569db"
    sha256 cellar: :any, sonoma:        "dc181fc89234bff0e83d1c5950311469775509d867af78b510bcebb188a924b2"
    sha256 cellar: :any, arm64_linux:   "a6433253e785c424eebf9ded1fcb8143ac68e6f8c8fb62de4f65f620ff3b4c08"
    sha256 cellar: :any, x86_64_linux:  "c5f353a7341bca44b809c415e87a10c3ef4987e9e53841c40b7c8aca87e120c1"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build
  depends_on "opencl-headers" => [:build, :test]

  conflicts_with "ocl-icd", because: "both install `lib/libOpenCL.so` library"

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
                   "-DCL_TARGET_OPENCL_VERSION=310",
                   "-I#{formula_opt_include("opencl-headers")}", "-I#{testpath}",
                   "-L#{lib}", "-lOpenCL"
    assert_match "ERROR: App log and stub log differ.", shell_output("#{testpath}/icd_loader_test", 1)
  end
end
