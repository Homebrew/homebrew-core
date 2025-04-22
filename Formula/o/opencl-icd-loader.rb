class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2024.10.24.tar.gz"
  sha256 "95f2f0cda375b13d2760290df044ebea9c6ff954a7d7faa0867422442c9174dc"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "da02c657410f1f99d71a8fb4a512a65dffb83725d0e3e5fe83c56dadd5195951"
    sha256 cellar: :any,                 arm64_sonoma:  "f36123fdfa33c94abf75c45da21db3e9ee754fc4c063424d2cd166ffe2eb7674"
    sha256 cellar: :any,                 arm64_ventura: "5a4d5eadae6145a4af771b5ad522c1aded5748287844d02dd22917f292a3fec6"
    sha256 cellar: :any,                 sonoma:        "a639175e931247933d74fc27cff123e75c313ab12b53d45037f58d86a0a15636"
    sha256 cellar: :any,                 ventura:       "738951620c894c8550ee9bec207375649f79c3b8dcbb8c13b528d19df336ed42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "197ba359c64d660b2a44bb0f9e688eddba9c033bbaf377b9d55c3a3daa8662d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86de1cb308f14d4b4bc63ad1bf3b7107a2ab8da41735bdbd287b584ce1902986"
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
                   "-DCL_TARGET_OPENCL_VERSION=300",
                   "-I#{Formula["opencl-headers"].opt_include}", "-I#{testpath}",
                   "-L#{lib}", "-lOpenCL"
    assert_match "ERROR: App log and stub log differ.", shell_output("#{testpath}/icd_loader_test", 1)
  end
end
