class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "7c663c3c41da9354b5af277bc2fd1d2360788050b4e0751a32bcd50e8abaef8f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c3adc9aa85652da4e19a571a8eb4b565b9b8035ce56fd276f2725bb902a7e9d"
    sha256 cellar: :any,                 arm64_sequoia: "5d301d5d5bcdaa7be22bafe95bcb6fdb9097bef450920027cbcffcdfdba7fc6d"
    sha256 cellar: :any,                 arm64_sonoma:  "4f2fc593061df83e56bfa19da797fdb1c24cd0dc004bfd6f374c3d8ce3c992aa"
    sha256 cellar: :any,                 sonoma:        "87f1dae191d3cd0d00e78ee11808bb488e0b1a10cb15e7b4f192680e8abb161d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48890260ead06a31bd0c5ff9c7754651b4904774c28421fbba9bf5b70799396a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f897a365243bdab2c0f39adfe11a92cd3d9b5191f52a45f2bfe62212146574b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
