class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.7.tar.gz"
  sha256 "6f57641fb12b019867a766e602252ed4ccb26d7354e3a15688fe9c85a391716e"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69d53f0a32469314ca4ee273beccc765ee4997d305b354e158e5d8ea7e0b46d5"
    sha256 cellar: :any,                 arm64_sequoia: "fd0ed2883fef93319cbfa75b9ba55fcd090b5647f3b3eef78bc8619adae94867"
    sha256 cellar: :any,                 arm64_sonoma:  "206e3e86cc89e4dcc6208b87cedba63046d9b8cbd32747c35a426dbc1b1af17a"
    sha256 cellar: :any,                 sonoma:        "ce90c48b801c352679a41307c4cdb1056dc385db3be7d028c6fe2bb16833b5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c36e02128fe2090edd4736414c731ba7dcd8fd9a7c6375a91a5e8952e3fe0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b987db335c3432e86f4e795d61d4b7d4cb0fc1946355da9735d11b76e76d774a"
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
