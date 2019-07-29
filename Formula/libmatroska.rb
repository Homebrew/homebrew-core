class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.5.2.tar.xz"
  sha256 "0ac6debfbf781d47f001b830aaf9be9dfbcefd13bcfb80ca5efc1c04b4a3c962"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "ed8d3ac8b50484c2db4dafc46a7bab0d59751ac4bb99d1f5c11d8e18f71024d5" => :mojave
    sha256 "4645660af5cf1737a3bc91815e6e82a466fbf82dd4f8f7cf483139871aa1f513" => :high_sierra
    sha256 "90faa3f9bbab4b0bba4777c5dfb89b00000dd49b8da104631a4eb2b76b9e45e9" => :sierra
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
