class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2022.09.30.tar.gz"
  sha256 "e9522fb736627dd4feae2a9c467a864e7d25bb715f808de8a04eea5a7d394b74"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22efc1dcec632e5833c3a425f6e2d127a981ab378dcb84ac35ded8023e96eed2"
    sha256 cellar: :any,                 arm64_monterey: "c2651735c2754fafb28778c09d975427e3e0c525e3e891d95ecb87f475e739b5"
    sha256 cellar: :any,                 arm64_big_sur:  "6c1c9e84ad1eee478db46aa61ab69b3b4298b348ea533849495f936ca599618b"
    sha256 cellar: :any,                 ventura:        "95465c48b4fd4afbfb309b77fc37487c593dfffba1e410cad8c38027f9159bbe"
    sha256 cellar: :any,                 monterey:       "be415adb029135720b2582ca1be926895d2ff0eec5161b1583bf0ff7d1192a99"
    sha256 cellar: :any,                 big_sur:        "372726d0569e8c0bbca945416273a4e1796569548faebf9667e185647d5cb8e0"
    sha256 cellar: :any,                 catalina:       "2f1c421750ee00063844e4076531455566c61defaf1a55779352186cf6fb6f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d441f7e3dff083bdc3231a0cb2c69432f6aa4b0359dba0263c39f8d18e8ef588"
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
