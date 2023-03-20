class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.6.tar.gz"
  sha256 "daa33d93a7b706e27368a162060df0246a7750c39a01a122d33b13f5c45d2029"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d693491cf6fbdfcb1af8182224f221e05d9616102154c2b89c204171fd0771a7"
    sha256 cellar: :any,                 arm64_monterey: "5e284bee8b44bf804ad98e89ec1651a5692675a444a34ff100c9c7364d7f014e"
    sha256 cellar: :any,                 arm64_big_sur:  "c35545e0fcf2649f8a109038b5111244b1439db93455e72117d60967a9de2b20"
    sha256 cellar: :any,                 ventura:        "e63936a21f703b5cb14046e933bc7107691de334406a91c87cb7e1aa7115246f"
    sha256 cellar: :any,                 monterey:       "e1ed7ef06f854f826505cf7ebd0eab915dcbbef7bbec2a34647b9c08ce4dd4a1"
    sha256 cellar: :any,                 big_sur:        "8244aa8ae5241b0871d5799ccfd92ea5c9982deef565759a0987f4e4aa4daa42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cff41929d6d580903bbaca126eef5a09894ba2ac421140c0a7b85fb125393c1"
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
