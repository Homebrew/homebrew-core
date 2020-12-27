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
    sha256 "3695ec52986316f6c6af1961b3f61ac56b913a45093e22559f247f6da117f587" => :big_sur
    sha256 "5bc31435b24ad0330c56cc7f92f1070882b9e256f60f96fdb17f0609321469e6" => :catalina
    sha256 "84f1b97ddf855d9e323305eeaf6d4e8d148ff43c1ef5bbb9f19e4b0d5cc2d8b9" => :mojave
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
