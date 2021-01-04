class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.1.tar.xz"
  sha256 "6e94c669405061aa0d25a523b9f1bea8ac73536e37721a110b3372c7f8717032"
  license "LGPL-2.1"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "9eade4a983de4668765edfeadde9708bfb548607d3ad267a6a3720694821df3e" => :big_sur
    sha256 "6b3cbb866b17716253f5c5c7d56812c71b866b642adf81032bfdab708956dbb8" => :arm64_big_sur
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
