class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.15.tar.gz"
  sha256 "445ed5b0ea4d9cf98be3a4f219e419628b123b61dec65ccb743ab9b07fbebdaa"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "46f85903df8fa937a528e47d7ea849abbaf784e82e2198aef9b2eb456a16660d"
    sha256 cellar: :any, arm64_sequoia: "60045526920eafba0f5eae6128e427e1c0fa64b095c91c0630f7c2c61eac2141"
    sha256 cellar: :any, arm64_sonoma:  "37e9d125cc100da86216332c63f29755ba3a4919820d3839176b6ed707f438c6"
    sha256 cellar: :any, sonoma:        "f909859881cd5111f58feba843ebafe68ef14f833b9975658c61b11d6514f5b1"
    sha256 cellar: :any, arm64_linux:   "951bbcb0f6bd6d5d61a2df299064871cde9c58d64ab4477fb3400e9a2e3e177b"
    sha256 cellar: :any, x86_64_linux:  "904c6981a4606e36485bbc1eed7f42262bae46f4d8d4ef83ac8bcb9cc0b71d2b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
