class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "58aad2b32c047070a52f1205b309bdae007442e0f983120e4ff57551eb6f10f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9056886cae9e3591511bbef200d0b79718959be9ac68f364bf7a2b221706b843"
    sha256 cellar: :any,                 arm64_sonoma:  "8948c7c401d3bf05e7ba64ba4fb6b761b9d19f99c8d8bfd9bfaecebc440125d1"
    sha256 cellar: :any,                 arm64_ventura: "d8a76305facaaa7bb3501bf964832263aadcdb3006d0334eeba850c42362ae41"
    sha256 cellar: :any,                 sonoma:        "2262a6d834c058798019765aae0715564b5e30715bd487c6636c478230649877"
    sha256 cellar: :any,                 ventura:       "a5f2a08d6ac61d88be9934ad1acde807742f3be7cb0b2bbe1fe2e2fa45b3bd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c331aa26cf88dba0b42a71ef7e01d0a778784b2efce77f81e21e56236d27066c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "imath"
  depends_on "libdeflate"

  uses_from_macos "zlib"

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-exr" do
      url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
      sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
    end

    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
