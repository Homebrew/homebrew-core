class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"

  bottle do
    cellar :any
    sha256 "6eec51edf0257ac922832bc7b7434f90bfe0dd324ef7b3763d1fe451fee12108" => :sierra
    sha256 "1cdcfc07c99f250ce0989a100f97c212161b191e1732f864827acbbd830bf46a" => :el_capitan
    sha256 "dc8f3a14ca6df136062d1b58003c6f1e531569deed0bef509fe5ea27e71a6cfe" => :yosemite
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
