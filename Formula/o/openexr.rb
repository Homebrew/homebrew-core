class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "c31d62f76cec06f738d4521f4062b51977e3cf6fb2644a1d505de3d291d78e2d"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "e292bf9bd14cf21037f74cdbe19c653ac0e6666717e1d790a8d59e39021c2933"
    sha256 cellar: :any, arm64_golden_gate: "4b76a1c75951b72b42c3ebe7a16cd427a062f62a782414ae9e6ae9fdf32f2421"
    sha256 cellar: :any, arm64_tahoe:       "7401c3eb1420c3b2c6d05a80babbcebe609b508b5c54be7100152d640342b34d"
    sha256 cellar: :any, arm64_sequoia:     "a46bcebe989ec649e36d8c6fb0e7f5f1b851114a49de43d07db33bf71f4e3160"
    sha256 cellar: :any, arm64_linux:       "7fc564c38dcf38255988c7dbf936a4e6fb6696b012f9368fdbee3e78962960b5"
    sha256 cellar: :any, x86_64_linux:      "3b6409b4438ce860437040f11f6a69132fafaa13a3e94573dc84cd575540522b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr", :test do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
