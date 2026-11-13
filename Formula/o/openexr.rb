class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "cedafe3171176d20baea4e887ceacc74cbe3a5a06fbb30d9f0a394a4416e5f7b"
  license "BSD-3-Clause"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c50df52fc1d9e18f876f47872da09982ebacd7a5215d21e2a316f30eda6517b1"
    sha256 cellar: :any, arm64_tahoe:       "492e8a795883eddaa56078a257bdb349b328d5c9e3c0d30e0b59eea09fab190e"
    sha256 cellar: :any, arm64_sequoia:     "5b674285b4bc5afe8d2f8904fd600970ae461fd544f7819aaebf836f4b63ff34"
    sha256 cellar: :any, arm64_linux:       "c8d5613feead8d9563a375cd68d31783086e9d3d467e9c0aa34e8ec225b9beda"
    sha256 cellar: :any, x86_64_linux:      "2c488e44fdaf41db692107aa468aa10bcb429fe9bcee7e125aca72c7a56296fa"
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

  deny_network_access!

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
