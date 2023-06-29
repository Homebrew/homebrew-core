class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.9.tar.gz"
  sha256 "103e902d3902800ab07b5f3a298be7afd2755312737b2cdbfa01326ff99dac07"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "522d4717b7c5e46a69f0e009e49467ef35d1122b5d2814fa1bbba8c8415bf899"
    sha256 cellar: :any,                 arm64_monterey: "143dd69dc50ee4ae8c49e65c61af20e9a5f3d4cbb5ad52b034b8aff058369760"
    sha256 cellar: :any,                 arm64_big_sur:  "0f6b9a84d80a7816cf8d594f57c3634642bd2fd9e49dd7d84f38bcebf53c4d01"
    sha256 cellar: :any,                 ventura:        "83ea8e863608baab4e8884d38252577ef5005509355d38651d55fc4785710501"
    sha256 cellar: :any,                 monterey:       "63865b9ceca1761f2bc161546d08a7cb3b144a4c8410c69933c243d8f751dc87"
    sha256 cellar: :any,                 big_sur:        "8e35254af423f989877b99f2728f09c170375217fd96cef3d94eea674b8f193d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5246f346180c9d3e163c39c56ce2d49efe7ff303afc52b1db523db2cde32bb41"
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
