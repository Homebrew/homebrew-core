class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.1.3.tar.gz"
  sha256 "6f70a624d1321319d8269a911c4032f24950cde52e76f46e9ecbebfcb762f28c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fced64362706423a154f34267febde96ae7b9400f2461928572e36bbc0a32ba4"
    sha256 cellar: :any,                 arm64_big_sur:  "ab723009a94026ae725e87542aebd00bc69992ac3f672ff6960930eb158819a1"
    sha256 cellar: :any,                 monterey:       "4e855c669b718fcec2c8755d80fea24a3d600475dc10445870e1aa33e4dfd112"
    sha256 cellar: :any,                 big_sur:        "922846fff4a126532cbba994521b8768f3ad9c6e4d11c175df4a51f333b8da87"
    sha256 cellar: :any,                 catalina:       "f9bf9db8861ba9c96ca5b76a03e986a20c4545528c7770dc1915044b7ef3c25e"
    sha256 cellar: :any,                 mojave:         "e2ab720e00d56143302a0c3af337e7605c8e2768cce9d5dadba3d28dfa28b904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1472cf78e5388c21d9ecb77f5f3998b66ebf701b1b8fea8119072510ce0fb7ce"
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
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
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
