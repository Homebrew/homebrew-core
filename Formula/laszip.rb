class Laszip < Formula
  desc "Lossless LiDAR compression"
  homepage "http://www.laszip.org/"
  url "https://github.com/LASzip/LASzip/archive/v2.2.0.tar.gz"
  sha256 "b8e8cc295f764b9d402bc587f3aac67c83ed8b39f1cb686b07c168579c61fbb2"
  head "https://github.com/LASzip/LASzip.git"

  bottle do
    cellar :any
    sha256 "9b3799014035a92909269d87f3756d98c83922c708c2ae0b2ac8f2c0ccc6f20e" => :sierra
    sha256 "3544d8dd1e7db052d685ecc588803dd8723172df160619d7451afe6ede7b884e" => :el_capitan
    sha256 "e757a001cce1bacae92297fedb006cd40a91e20035e84e071664d89a55862af5" => :yosemite
    sha256 "7691838134d631d123cfba57a05ab17213517442457454c0967b372d5cb7f0c3" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/laszippertest"
  end
end
