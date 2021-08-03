class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.1.1.tar.gz"
  sha256 "045254e201c0f87d1d1a4b2b5815c4ae54845af2e6ec0ab88e979b5fdb30a86e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b7dc2383d60ba2218f62dfcbca42f27b9237c611a3c7eb1cafde5e7d576e8bbf"
    sha256 cellar: :any,                 big_sur:       "e4069533b0e8040b39f75f6a12e5015143efb1d89748b2904dfb7db260fd1375"
    sha256 cellar: :any,                 catalina:      "7cab58e014d67301c1aff5fb4dc833fb935d7e4129b18cc3c146ea9d72051a1a"
    sha256 cellar: :any,                 mojave:        "4af915067fa26e56d8dd2bdfa34cbbd1475516339bbd0d0e65444bc902efedde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9475ab05d9dfbe2f71c787b823dfa05c8bbfb9b235a7f8a0d7eac6c682201e"
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
