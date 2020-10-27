class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.0.tar.xz"
  sha256 "80abc9a82549615018798ee704997270a39b43de9a6e7e0d23b62f8ce682c4b3"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "141c96c12242fb7db7e292f487b9e45be1c4c84a4e7d94f0eab2ccb0d72d8285" => :catalina
    sha256 "010e20e9b1779db7e69666a10c93bfb6a87c06e513ed80c89ea319c674eb215d" => :mojave
    sha256 "505546edc98c4e9a382c35d17e299023f2ca91b2641f71691993dc99690f79b0" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
