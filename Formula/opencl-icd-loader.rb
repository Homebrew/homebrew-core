class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "e9522fb736627dd4feae2a9c467a864e7d25bb715f808de8a04eea5a7d394b74"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15cff92eafa5c7d474f137e6fb69ff5d52abc4c4c0031438d4721a1d39d781e6"
    sha256 cellar: :any,                 arm64_big_sur:  "c70178db7d6c7c43a3771918230cc7d35bdb87461ff3dea2e098b1080e68cfa0"
    sha256 cellar: :any,                 monterey:       "ac6a6b535ab5d5cf97eeb8455b9cb347cc59013a7e860b71a1429b3909346b13"
    sha256 cellar: :any,                 big_sur:        "6367270f66a7ab3b8771661020383c765177a1300924338b7a1c40e3355fae86"
    sha256 cellar: :any,                 catalina:       "078e23caa37370d228c9c68f50caa5512fcaee7312788f8a1bfd7a36df66c2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65690278ba66c107da635f94ff1e00f4c91eb27712f48197905238416f57cf2"
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
