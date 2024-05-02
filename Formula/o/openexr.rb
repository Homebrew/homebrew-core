class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.2.4.tar.gz"
  sha256 "81e6518f2c4656fdeaf18a018f135e96a96e7f66dbe1c1f05860dd94772176cc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "49b4acf727abd6a736d9d7cf8b38fe96ef3f89979523186ce4eb947d5478b772"
    sha256 cellar: :any,                 arm64_ventura:  "690f103efb1ab0a421cc8c7aa4c0eb0c1715f3e35e26b05f54820bc7896c16ef"
    sha256 cellar: :any,                 arm64_monterey: "eafdc1854757f9215568e38005d69884c3da63b23d62cc6496e95430d2713796"
    sha256 cellar: :any,                 sonoma:         "e2d68cb84ae057f4323e7f52214ddb1c3db955a02db865acddcc8d41828ef445"
    sha256 cellar: :any,                 ventura:        "893b120aee538446c12c39d819f2a56a54d4493558d6c6e339ef3f0f2a382607"
    sha256 cellar: :any,                 monterey:       "bc8c4411b513c76de4c416642341c8f72b29a4fff10f0bcfc2c13c17ef899261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c839fd2991b3cc8a66a5e5fa6aa4d86e3d9621280d56b24219900c81ed7d1e"
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
