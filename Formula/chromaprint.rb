class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-1.4.3.tar.gz"
  sha256 "ea18608b76fb88e0203b7d3e1833fb125ce9bb61efe22c6e169a50c52c457f82"

  bottle do
    cellar :any
    sha256 "88b395f32a669162b2d270c9f38711fe884aabacc7c7ce9062dbf420d5445a21" => :mojave
    sha256 "3d0ae4279d4d3fa0fad24c434e82032384256ed1613e89e7b601e1f02ceaa596" => :high_sierra
    sha256 "fc91e7116562484496de75f3e3e0a7a61771b9826b6f3a4497af411df2683290" => :sierra
    sha256 "799c9c907b020aed48763162b996a672d42b3b8dde5a53381e28818ccd0981dc" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
