class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.3/libjpeg-turbo-2.1.3.tar.gz"
  sha256 "467b310903832b033fe56cd37720d1b73a6a3bd0171dbf6ff0b620385f4f76d0"
  license "IJG"
  revision 1
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6a614ed2a59f896d9ddf7a291b55a36a13bee559ce05d407636cea8ec592ddfd"
    sha256 cellar: :any,                 arm64_big_sur:  "f3b0032dac493b4ac3ad56e33bdc9e8948131419433ab28c0e5d954a71e791e5"
    sha256 cellar: :any,                 monterey:       "a66e3544895b4aeb671a113dad6754f3470fd5247b21e4bd22bd202398837f59"
    sha256 cellar: :any,                 big_sur:        "4a8ced6c2bba4c506a36c895b393ab7df6446d491fff2d4817daff1f5dbb0558"
    sha256 cellar: :any,                 catalina:       "0d0336c43da8db6d4cff0988fd881cc8960c95bd27a614e5e07e03b82779b9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4715fd09fa55e2dedb1f68e1199119927177005157b2b2a7911a832c726cef2"
  end

  depends_on "cmake" => :build

  on_intel do
    # Required only for x86 SIMD extensions.
    depends_on "nasm" => :build
  end

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bin/cjpeg", "bin/djpeg", "bin/jpegtran", "bin/rdjpgcom", "bin/wrjpgcom"
  link_overwrite "include/jconfig.h", "include/jerror.h", "include/jmorecfg.h", "include/jpeglib.h"
  link_overwrite "lib/libjpeg.dylib", "lib/libjpeg.so", "lib/libjpeg.a", "lib/pkgconfig/libjpeg.pc"
  link_overwrite "share/man/man1/cjpeg.1", "share/man/man1/djpeg.1", "share/man/man1/jpegtran.1",
                 "share/man/man1/rdjpgcom.1", "share/man/man1/wrjpgcom.1"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_JPEG8=1", *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "test"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_predicate testpath/"out.jpg", :exist?
  end
end
