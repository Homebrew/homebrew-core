class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2023.12.14.tar.gz"
  sha256 "af8df96f1e1030329e8d4892ba3aa761b923838d4c689ef52d97822ab0bd8917"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "785d86639b5e173c1e54998c9af87ce6556814da2b19fb1574e1ab52d881bf18"
    sha256 cellar: :any,                 arm64_ventura:  "c273e98ce374d8d0628e91dfaabeec8ba0ff114c030173d868df3c7175a5f03b"
    sha256 cellar: :any,                 arm64_monterey: "a31fd776a5d9948f51e38b406274b4351ef0e9f4e005172472c7675b3e11b0a6"
    sha256 cellar: :any,                 sonoma:         "d3f967cefe76cbc8d6cff828a12f34695553baee5a270f7d0e42de281364b74b"
    sha256 cellar: :any,                 ventura:        "559af3eefe68983128cb17d3e2960e0625603bcf6819da7c0c7797e5d757f3dd"
    sha256 cellar: :any,                 monterey:       "4db247d8bf4b69cb87f9dce24477a360ef6a53106142de25e025cf1051409639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b99bd58c9d2527d4cab97efa0ff7955d0bac962fbab09a2afdbb4eab6b3ca151"
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
