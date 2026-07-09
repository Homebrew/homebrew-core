class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.13.tar.gz"
  sha256 "1ed0cee48ac8c77da235c8ca8ab85d031d43cd790eda36af87fed4cf316cf2df"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7f0c9903b35ea56fe6aac919c874a3a98b2753c43b0e3fd4eec87895d49791de"
    sha256 cellar: :any, arm64_sequoia: "3f211cd94521297c1df3c0cef9e4fe2ed4d1eb237054efcde7e8220d23750a64"
    sha256 cellar: :any, arm64_sonoma:  "68da221e8b87f3b6332bc9916b0653980e13f1c71836e474020cef266653348a"
    sha256 cellar: :any, sonoma:        "0db6e609fc031710fa0b8be4709e63a3f31de4395cbf54b82c7089aa8b90db13"
    sha256 cellar: :any, arm64_linux:   "e052b33b637f334655d365f845f8eedc355a45865005d87fe92884289a1a201e"
    sha256 cellar: :any, x86_64_linux:  "79d8f6335bee9db32509f40b96e1eb0e2065bc6dd09dbc52077403e86f821149"
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
