class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.6/libjpeg-turbo-2.0.6.tar.gz"
  sha256 "d74b92ac33b0e3657123ddcf6728788c90dc84dcb6a52013d758af3c4af481bb"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "81e58cf5666e9adc810f1fd7b5ab6a9b45a66d65c7d36d73c94430e1432e9971" => :big_sur
    sha256 "ed33cdd98575680b68055415bc8416e4ff84cb5a458e65924027ef1726e37261" => :arm64_big_sur
    sha256 "30d3f9a97040a6070c5bf183e4ae5e2f7f7cb1a233a0c987e5cb67f82939c4ad" => :catalina
    sha256 "4b087792a6794f715924c735882adb54314da0e2927cd810b0449e0ac061f095" => :mojave
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
    system "cmake", ".", "-DWITH_JPEG8=1",
                         "-DCMAKE_INSTALL_LIBDIR=#{lib}",
                         *args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
