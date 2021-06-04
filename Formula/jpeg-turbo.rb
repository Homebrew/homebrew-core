class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.0/libjpeg-turbo-2.1.0.tar.gz"
  sha256 "bef89803e506f27715c5627b1e3219c95b80fc31465d4452de2a909d382e4444"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 arm64_big_sur: "88c325eabb7b63c8df6c94e2830a61262cd1d1b1578f1e7a18c8a1ec35585a0d"
    sha256 big_sur:       "d75de3940ae5b5d5117e50b8167aed9cf672bf490a0ef0752f2a092079d64cff"
    sha256 catalina:      "6896a17259ac12146111d562538ed144a25ed18c704f503294a2043ae0d1e28a"
    sha256 mojave:        "b917a78fb0222d9423eda3728c4c0ee63a83ef232a7a4f21036307d92a27d68f"
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
