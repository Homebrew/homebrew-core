class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.1.1.tar.gz"
  sha256 "045254e201c0f87d1d1a4b2b5815c4ae54845af2e6ec0ab88e979b5fdb30a86e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3d3257d9750eb7a66a3e161f3e8bfa7cfb405937325f5b91bc02fd7ac9a89c35"
    sha256 cellar: :any,                 big_sur:       "92108b32e13d57e30e48d5bfa4adbe360b303cc19e78b7b7cb8df7865d66c449"
    sha256 cellar: :any,                 catalina:      "40d2ebcc43006954145c03e9636b471484aaf613a48adb8558f3d3f005a22c80"
    sha256 cellar: :any,                 mojave:        "3261656535c6449dd4b1d4a4a52d91c571127bc58ab40374510d2891cdea2cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e9cca16104e95abea8c3db9a00adb783bc08f6694d8015a291987a5da8048c1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

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
