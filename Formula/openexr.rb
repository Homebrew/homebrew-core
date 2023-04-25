class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.7.tar.gz"
  sha256 "78dbca39115a1c526e6728588753955ee75fa7f5bb1a6e238bed5b6d66f91fd7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af3bf3c18721d74bd6e3ae7ca18af940b18d598539b69f5872e2d5e130f6e83c"
    sha256 cellar: :any,                 arm64_monterey: "4eadfb370990348330f6926081e23dfbf24824ca114f5c5e346251f0bb766b89"
    sha256 cellar: :any,                 arm64_big_sur:  "c967d62720920952652225959c9720fa23095d9d4f7c51c6bcef3fdee8f19b68"
    sha256 cellar: :any,                 ventura:        "a56b65bb841761e73cef93fb0d29a3419603a469e82dbe981bd4241adaa6f3a1"
    sha256 cellar: :any,                 monterey:       "49735200012f8571dcad5aed537dd3f11fda0736c8d1a283ca4357538b9d5f16"
    sha256 cellar: :any,                 big_sur:        "33e64c16c41ffdae87a17fad4e4ef5f7783e35f93e849a2be6fc36e648c96654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc85fb2f2b332515511f56211372262f707dbe90f7f4cb9a60be1cc701ad0956"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
