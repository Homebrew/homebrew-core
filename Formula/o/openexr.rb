class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.15.tar.gz"
  sha256 "445ed5b0ea4d9cf98be3a4f219e419628b123b61dec65ccb743ab9b07fbebdaa"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "323a18f3c7559329d1acf951fde64e45a1eb1f80bd23d9f5fd3a39bb83d96920"
    sha256 cellar: :any, arm64_tahoe:       "d39dec713189bc50b736633144a4e2470873bd9217c5c143550bdb3def9d6ac8"
    sha256 cellar: :any, arm64_sequoia:     "cb318ab0fa2e9ed37ef5499930bc13425c4bb9a4f12e51b4903f8a1b7d4c6749"
    sha256 cellar: :any, arm64_linux:       "7fa5c416ca58a9371d46c7c425daffb6bb597ddb2cb7a1ca39f7e434fa1e7994"
    sha256 cellar: :any, x86_64_linux:      "de98d6d88cf196dd5aee2a9dd95e4c5d1dfcb03787490516f03c1494ae5434e2"
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
