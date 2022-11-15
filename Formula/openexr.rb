class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.1.5.tar.gz"
  sha256 "93925805c1fc4f8162b35f0ae109c4a75344e6decae5a240afdfce25f8a433ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "abbb61fdcaa3c461dbfca5176764409f11c8900d6a39d2d6a069fb3205d400e2"
    sha256 cellar: :any,                 arm64_monterey: "633811a87f2087ee77e05aeb3bdbaea9cede0c010c0e4ddf5212b1f7dc773369"
    sha256 cellar: :any,                 arm64_big_sur:  "a86f1c3252e421bb3c511fd17d02031eb62d19fc35be4e332835ef8023bc6903"
    sha256 cellar: :any,                 ventura:        "2bac7697182d779f0b0ec1c3cbf1746211ad59b923066f0fdfbafa56015ddd9a"
    sha256 cellar: :any,                 monterey:       "7b5eac70a2b63764fe1dc4efa787b04f65f7566413b2727a3f5366256b007723"
    sha256 cellar: :any,                 big_sur:        "db79b777e18b0c58f9b9d856e681a62e54ce91e54c8a1a5faaf4a6a98e515871"
    sha256 cellar: :any,                 catalina:       "264da60466034171be1337d9b18f9293122ad82c364de5d037e7fab468525196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37824df7fbc74d4e2f2b9837e14917b707fffdc94bbec39fe0babda17d0c9781"
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
