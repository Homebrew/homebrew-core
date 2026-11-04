class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "ff1de95f4031c1c57c633e647dc97c15282d3aa3bc7fb90745f00f74de4a054f"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b3c31336f78d66f7d3f9e009df226f89466898425ba4342958b9ca8c46a41c3"
    sha256 cellar: :any, arm64_tahoe:       "aaa393713c18c01cd3aad38ec469026c279bf22e255413b816f227167db1abf0"
    sha256 cellar: :any, arm64_sequoia:     "3ad2bf6770cdf438f118e30d78ad0d75100156337d0d59a85f2215a150bd6249"
    sha256 cellar: :any, arm64_linux:       "f81283826fdcc89f1bdfa17ca3c65f2cf0b7e6f9396aae897fdd63d3dcf52aaa"
    sha256 cellar: :any, x86_64_linux:      "860810a9a2dd6661ae5b55d0d335bf648f7d56654e5b89e341a8d9dc3cfc52a5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "imath"
  depends_on "libdeflate"
  depends_on "openjph"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # These used to be provided by `ilmbase`
  link_overwrite "include/OpenEXR"
  link_overwrite "lib/libIex.dylib"
  link_overwrite "lib/libIex.so"
  link_overwrite "lib/libIlmThread.dylib"
  link_overwrite "lib/libIlmThread.so"

  resource "homebrew-exr", :test do
    url "https://github.com/AcademySoftwareFoundation/openexr-images/raw/f17e353fbfcde3406fe02675f4d92aeae422a560/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("homebrew-exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
