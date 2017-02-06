class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "http://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.3.1.tar.gz"
  sha256 "b88e53ccffc00f83717f2e686dbed047b95f011187af2b7a23ba7f5cd3537679"

  bottle do
    cellar :any
    sha256 "1b9ee05f76a7b62f4f05c8ff3272270dc70238b629511d23bd80b3ae6a533f1e" => :el_capitan
    sha256 "60fb27db0f09c5ca489c9e9201260a667c58eef7c99d81274b3f1afa2d2dcd30" => :yosemite
    sha256 "902135b0b046e3915edf4fb7446390f10fca11a4bb84e73db2a7537d71108790" => :mavericks
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
