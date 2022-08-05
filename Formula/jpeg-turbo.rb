class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.3/libjpeg-turbo-2.1.3.tar.gz"
  sha256 "467b310903832b033fe56cd37720d1b73a6a3bd0171dbf6ff0b620385f4f76d0"
  license "IJG"
  revision 1
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0fe5fd23465784fe56f97c29589a72eacc21f8fb75f8c84e69da724637aee262"
    sha256 cellar: :any,                 arm64_big_sur:  "e47a04f605090bfa71f2bbc71c84ea4f2a0c3986ccc8f61859b31247ed0e9e08"
    sha256 cellar: :any,                 monterey:       "1ee0a0cfd7ceeae5b1bcccc105d47ba9adbf74e53eccde118b4849b654a9cdb9"
    sha256 cellar: :any,                 big_sur:        "14c6fdc80b47eef6b88114cad94f0b311d8d2766dae25ba2660797ccaaa1f4da"
    sha256 cellar: :any,                 catalina:       "54b3b74ffd0af4ee85a3984af36f8cce5be166a2dd74488e64f266716fcfb5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc674d48947c45d2018420a3e0eb4ae4d0778984ad5a478e165498cafe9b118"
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
