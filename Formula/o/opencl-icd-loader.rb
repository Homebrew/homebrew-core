class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2023.04.17.tar.gz"
  sha256 "173bdc4f321d550b6578ad2aafc2832f25fbb36041f095e6221025f74134b876"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "03e31391a1d1891d9781ad51a4796adbbcfd2b4bd4ba691a3166c2391e18a2eb"
    sha256 cellar: :any,                 arm64_ventura:  "70649fdb781ddc422081204849419bdcb28cd7ed44ff7a676938690028a90435"
    sha256 cellar: :any,                 arm64_monterey: "83849eb94958bbc677f36d9c25d4d726f8250670fe04bb8281805fb3cda6c0b5"
    sha256 cellar: :any,                 arm64_big_sur:  "c957def164ce93872beb07e0ed347fb1d84641172db8fee3da512e04e759039c"
    sha256 cellar: :any,                 sonoma:         "91f8e09bb1f604cbd26bef94a3ac7ef2aa55c49f4b9839ae80822743cebb8890"
    sha256 cellar: :any,                 ventura:        "cb670002a1bb0c9cd2802bcbd7c4a433dbcfc183991ebd52f7a02e0c32d95a20"
    sha256 cellar: :any,                 monterey:       "59f53963c7f6f0451abb1e65d97bf49304d1ef6dd05dd5192781aedd53f33f04"
    sha256 cellar: :any,                 big_sur:        "e8f020c775ad82a447c9e07182aa9a3619fe1c67cd53053dcb66cae3c9e2f51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3cf98dad47d2f96e9ec3bd6cf2e1e41ef10259ef4de754c2927ce560b85ae16"
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
