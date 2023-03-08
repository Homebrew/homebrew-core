class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.5.tar.gz"
  sha256 "93925805c1fc4f8162b35f0ae109c4a75344e6decae5a240afdfce25f8a433ec"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ec440463c50f2d8de6a55d41054d43f2bc61fcba5f0d4fd1c4dd8c02f1e123c"
    sha256 cellar: :any,                 arm64_monterey: "0bb316cc2d29f68df2ac84d1b02a0173b1023a6c8e9bdee56fbaa269dd214b35"
    sha256 cellar: :any,                 arm64_big_sur:  "0e21bd94255450a9ab028065802680af7364b1a59465f5bce3ea8e0be0e0fe9a"
    sha256 cellar: :any,                 ventura:        "663c79c379b05f42424446cc19e687283a1e40ebdc108472f24b251baa517e13"
    sha256 cellar: :any,                 monterey:       "a2ce22e877661986c45c1f088faf821f63e082fc06e5c1c694dd0ed055875d16"
    sha256 cellar: :any,                 big_sur:        "ccee390858581429454b282a9060e9acc20e989ef2bef39286b3ddf6a72d8448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da6c6b4024f01ab623a4e66e0d25d1bd60d3600fa4829e9e0eee8d26ebb2d17"
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

  resource "exr" do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
