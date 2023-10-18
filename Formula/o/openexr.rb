class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/v3.2.1.tar.gz"
  sha256 "61e175aa2203399fb3c8c2288752fbea3c2637680d50b6e306ea5f8ffdd46a9b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48cedb17ec3aad949e172fbf30cdcf669bce6b7a6b65a62a0ffbb27d5183c813"
    sha256 cellar: :any,                 arm64_ventura:  "29e6b7abc63489d0ebf8540b3e9f9f6f3ae9e1433f3208480c9a7a419f9cd008"
    sha256 cellar: :any,                 arm64_monterey: "fab546a78c5da96eb44d8cedbdcc46d701cc2a34fc9452294201a95925761155"
    sha256 cellar: :any,                 sonoma:         "89082b132cee8b5a74d69f97d60db99d3108f1f2f4b0d59ce994c3dcc6df7266"
    sha256 cellar: :any,                 ventura:        "7360050f81625cb8771c53844303fb0cb04d402acc012ee012d57878a5474bd9"
    sha256 cellar: :any,                 monterey:       "c6db118270c7cc6e2006ce55c26bed831ef58902b96f757f9bfa25e62223976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac542ea50628d230966c9659e0c392c27ee49d24ffd215e45b46a8f1afb28c2e"
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
