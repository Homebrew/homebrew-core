class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.8.tar.gz"
  sha256 "3ff47111ef7e5da6f69330e66e1e90ae620b79df1cedf2512bb9bffe86c2c617"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c0cb66b561820c914fa114ed3f913e0b9ae9484b1224fc21b0b2abe0e8652a47"
    sha256 cellar: :any,                 arm64_monterey: "8bdf7329edc1dab722f4e0aac3b1b47dbaef1a34309f898714c52246d33b9f5c"
    sha256 cellar: :any,                 arm64_big_sur:  "b132db1b52076d3e0a18d499b89c1536e01bab30f5eee31b6156cc7d1c9c14b6"
    sha256 cellar: :any,                 ventura:        "004988d58d6a35b4ae890733d5397c6d46eeb589b843d3389b9ad06593102798"
    sha256 cellar: :any,                 monterey:       "f6bb8af74eec8baedd1f84247e7dde412e2b46ae544e3a1e794941f8dec1a88d"
    sha256 cellar: :any,                 big_sur:        "b862e857e6709f8322b5480236070986ebe7da4ace0b973fe395808465208259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2287d00b0983b8c48362cdcf958b7a278a3041ce181df2b514de86d02ae8d8e6"
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
