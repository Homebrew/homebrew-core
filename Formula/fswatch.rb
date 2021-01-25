class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.15.0/fswatch-1.15.0.tar.gz"
  sha256 "26b4a002dc9c5f0a5a7605e2d9c60588ea338c077fccfa4473d2b9b8b8bb6f06"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "f0e4988d417dc53f21f03a82358900a31be9f2962b067bddc49c9d786189d5e4" => :big_sur
    sha256 "12f1acafc38cc38fddb8a221897ace28a95b6927b1708c52cd764b0aa56472dd" => :arm64_big_sur
    sha256 "77233b7d6c11644f14682862d613ed37a5eda86ba1ec5a6ea3c18b75ccafe906" => :catalina
    sha256 "2602ae4b5b43cb63ec6a249bdf8b1e81b124ae18392f01a2a8ebf0faec1ac5ff" => :mojave
    sha256 "057894d713ee24ea5e64c0db014e1593cee8eb253bbb962c68a6426a25f39c9e" => :high_sierra
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
