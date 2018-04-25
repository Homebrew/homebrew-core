class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.9.tar.xz"
  sha256 "38a61dd5d87c070928b5deb3922b63b2b83c09e2e4a10f9393eecb6afa9795c8"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "1f892100068d00d8a6d8d8026c09c155bd4f988d19d61380f1ba88426c72fdb7" => :high_sierra
    sha256 "4930a15c41e6be209554d3015b4d8b27fe6fad3b96a6b91e3686c9650ba55d6c" => :sierra
    sha256 "60c6aea336b9d18883da2bdccbd1979836e0803232f57c688806c5886969912c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
