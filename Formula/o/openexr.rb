class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v3.4.9.tar.gz"
  sha256 "328c6fcd794b2538d71c65b401264e6745cf65cbc18f404e55ec3c0230d2373c"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e78825b60a123eff02481cf191d648a04da674b010779099fbd1ab41e0b773da"
    sha256 cellar: :any,                 arm64_sequoia: "b745ec8a846ea912c1bf98a7f709470d2f59f89114113e3193e37fd007d352f9"
    sha256 cellar: :any,                 arm64_sonoma:  "c5edd11bd31bd26302873cb486ac9bb270ec75020bed040f9b90f359a2c6172d"
    sha256 cellar: :any,                 sonoma:        "2c8381fe0dcdc928ed5b2b1b888c58b51cb70b805f860006c3ed2d842d498ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb50118ed64e239a491ecee795d66d3b04241636df8c4393c9658912de93280b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1925ed2f27bdada9a4666311c74e2650846739c848fe9053603404953fa998"
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
