class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.5.3.tar.gz"
  sha256 "ff1de95f4031c1c57c633e647dc97c15282d3aa3bc7fb90745f00f74de4a054f"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3a3b5b63f3c3b538534cba64bf6eb3a3ac2fa696fb644235a14ca923e8b8f412"
    sha256 cellar: :any, arm64_tahoe:       "b3a6ad7e8364cf139e7feb137ba8dffeb844ff597d5b68415aa527782ded33e8"
    sha256 cellar: :any, arm64_sequoia:     "fd371a894a6197dad5a71d0098f42c20b41879eac7b00f15995e8c1b5ea1eb18"
    sha256 cellar: :any, arm64_linux:       "2bab7e6525266a3989ec704984db69f2a49aa3dc1330a2a62d1812119b9f40f6"
    sha256 cellar: :any, x86_64_linux:      "1fe59f6d3b20bb61f648f3798dec916290479899cfc340a010d4f4dbb04ed116"
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
