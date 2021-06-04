class OpenexrAT2 < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "50b8cf3f50c439e8a96c01ba4a899f82c0e287f144c5216bdd8ecb8b7da5c957"
    sha256 big_sur:       "152fc852e2e933cc5e9eb87090ef68dfc22727937dc9812bdfe9f47c8ff55c1b"
    sha256 catalina:      "cd219a2ea44a1c0db8dd195fac4f81998c5b453b01b6ba3f98f0868266c7918d"
    sha256 mojave:        "2d642d93482b12a3339ddb9fc9ff9914feb32ace5fcfebd6550598f4c8dd72bb"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-04-01", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
