class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  revision 2

  bottle do
    cellar :any
    sha256 "1e4f143eb5fcbbcb3ef602db9f1747e260fce6eafcc13eb22cac0610508b2b51" => :high_sierra
    sha256 "dfcfc211eaddb20b77cf4de1896c052952299c7a3d2374a6f907835cbb0f7672" => :sierra
    sha256 "9de1741c37d42eadc42a3dd6990c667f5ddf75a54ade98d497cfb4b44aff77d9" => :el_capitan
    sha256 "754a2b714768295a5230f65db0d3b6d606817a757c58c71e1c0332feb8e81621" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

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
