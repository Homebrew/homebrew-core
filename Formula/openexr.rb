class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.1.5.tar.gz"
  sha256 "93925805c1fc4f8162b35f0ae109c4a75344e6decae5a240afdfce25f8a433ec"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c0e4a96ccf31d34fe67da7fcf9bc581ebc64bbbec141127ad0fad087c01a2581"
    sha256 cellar: :any,                 arm64_big_sur:  "991ec0d21d840c77f20e45936ac6420eb65afa66ed3ff9baa4519f2f132e99ae"
    sha256 cellar: :any,                 monterey:       "2709b4deb3595f5d3649e725a78f30ab74d7b8634d57c8545edcd4ca735683d0"
    sha256 cellar: :any,                 big_sur:        "fa2267c26e2ae530089dd70e700c4886547623b77d2671ac1f82fdaef0de1c3b"
    sha256 cellar: :any,                 catalina:       "ce12dfc0252dfaaf13e25fd1b2eb9c22d4d4d1820561ed65d10df769286f1df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbcf828deeb1595e66d2a5e03f7d3d82a2c21787bc8a587d438b96138a8edc8"
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
