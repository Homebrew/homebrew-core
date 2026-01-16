class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "7c663c3c41da9354b5af277bc2fd1d2360788050b4e0751a32bcd50e8abaef8f"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f178082410e7e565f6c49529ae469389b370ee610dc8fad1fa00443c335e5e8"
    sha256 cellar: :any,                 arm64_sequoia: "fa612fb4903658f936a5f88b156375655da7b9dcd48bf92909ad2e72bacbc52a"
    sha256 cellar: :any,                 arm64_sonoma:  "4b5b405edce030ff8cd9f5dd2f9e057cf4a72d7b0616a3e82a0433a8ec91a467"
    sha256 cellar: :any,                 sonoma:        "e0571f29298064fc0ff0e3bb5aebb3b91d1044df0ecdea6bbd13cca20c79036a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95622a65b05748afcd6f5c3446148b1cbdeae7f79d42f402d35c0dbaa89586ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a8d7b4217b6c949a3d2fef741587b5dcfd4b8b92e20a66f9a3ed2e2724be0d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

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
