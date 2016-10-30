class Libcuefile < Formula
  desc "Library to work with CUE files"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/libcuefile_r475.tar.gz"
  version "r475"
  sha256 "b681ca6772b3f64010d24de57361faecf426ee6182f5969fcf29b3f649133fe7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "66ec2d9281a5459326a1b2d220b9f68fa241a6b9f8370324377af6751d60b7fd" => :sierra
    sha256 "fc48e0953e3df489f37ee30214bd50b07020955b02f957a90c699474f09ef974" => :el_capitan
    sha256 "427a043ee4dc777743c80a836c5fa69c4de91ea2510f740db099224f95ed38b4" => :yosemite
    sha256 "b3336424f211dfdd684537b4674afbe32e86179d9cf36dd3c07c3cb0e624cbb8" => :mavericks
    sha256 "83b2dfda39f5ba7cf0a30c7409df5bac3b4cb78e4d6a855cacb27cc9ba560415" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    include.install "include/cuetools/"
  end
end
