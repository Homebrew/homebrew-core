class OpenclIcdLoader < Formula
  desc "OpenCL Installable Client Driver (ICD) Loader"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/refs/tags/v2025.07.22.tar.gz"
  sha256 "dff7a0b11ad5b63a669358e3476e3dc889a4a361674e5b69b267b944d0794142"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-ICD-Loader.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0d457a1acf0efbcc69f119d0cebad5a3cb5c073690e94349c3bfdcfde5f6c77"
    sha256 cellar: :any,                 arm64_sequoia: "bf65ff7f27a7877c993902277e68ff4b88e5e49a15fbd9ceb310352dc16a5793"
    sha256 cellar: :any,                 arm64_sonoma:  "5d863bc7eb594b7a84db8a789772d4e28fa55564c07ec34b8b2ed9e8f0936149"
    sha256 cellar: :any,                 arm64_ventura: "3d8ba3a3c64ce7cb9f0c9a3185f8a432cd8e8bd08fb57ab8b5446f7f85db9e9a"
    sha256 cellar: :any,                 sonoma:        "3b29127cbd3ad9bfd0c59cea68ba772ce5c1c4e323b5d566d5249a1528b869b9"
    sha256 cellar: :any,                 ventura:       "fd9899b082534a219d434469052716a6a9f016b9a9fdc15a355b8e5ee2ee075a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74bad9df1b4a44f9f0675fabf03d7af9225993f5c3144f4104db82cace1d42cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaff23dec7418eeb114b986687c61f1e00aa3262d1a9d0843d06dbfe900fa4d0"
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
