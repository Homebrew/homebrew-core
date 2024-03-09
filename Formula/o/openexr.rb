class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "f3f6c4165694d5c09e478a791eae69847cadb1333a2948ca222aa09f145eba63"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "52f5d88e6e1a095f9b0e915b10fa4e55df21082fb062d551e8337d6ff403cc4a"
    sha256 cellar: :any,                 arm64_ventura:  "a3ed8a342ecba84d2198f09409491ab2600c9d6c9de9238a042387fdb51364f5"
    sha256 cellar: :any,                 arm64_monterey: "2aead86740b0444392702f032727ef98a92ff1ddc07956ffd4b7d8e7ac3b5590"
    sha256 cellar: :any,                 sonoma:         "e0ea5806a696d880a70e8db1d8f4f74ae66868a1d5131290fec91e75c82f4042"
    sha256 cellar: :any,                 ventura:        "ca90562b3cc6fb315edd0b282aa0628a89683f52c01a9270775a42ab9ec44b3e"
    sha256 cellar: :any,                 monterey:       "f8b0d9bed2412b8cab4936f8b1449515a7871856059589d3f6b58ca1d3e02c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa03a5ebab2ce2e9f9ac55031ba79a038af7a39137023ee7bd74e3a460e9fb0"
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
