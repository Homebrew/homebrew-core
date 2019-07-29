class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.2.0.tar.gz"
  sha256 "b7ed29c3638c93fbc974d56c85afbf0bfeca6c37ed0522af57415a072839b448"

  bottle do
    cellar :any
    sha256 "176f261b4bae02fd8e2c7c682b56cd86c4f90359dc974f3f0b488576bfc34032" => :mojave
    sha256 "6e277aace22ab9b1a621959e4814d6423370627930243ad72098341565acd836" => :high_sierra
    sha256 "61661c9f07b2213878a9b61e3920ffc23ee8a6c918cf8b4235124a6a8d6e63a6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/icemon", "--version"
  end
end
