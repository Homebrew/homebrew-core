class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.5/libjpeg-turbo-2.1.5.tar.gz"
  sha256 "bc12bc9dce55300c6bf4342bc233bcc26bd38bf289eedf147360d731c668ddaf"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d00e1ed5362087315ba0d537102311e6d8432c5cbe9296697141a02d53a6cdbe"
    sha256 cellar: :any,                 arm64_monterey: "3a3c98f98547a73ed8a7d63df80d2693b090157c23b284e4cdc768984e17ebbb"
    sha256 cellar: :any,                 arm64_big_sur:  "3f665c70d244ee7db9619b5ac7523f1a5f77d5a983280751fb4e7e727173026e"
    sha256 cellar: :any,                 ventura:        "c42a466d35b221dceeb01f1d2533c861a2e0c711e8e9e8586d840a44b3da2a23"
    sha256 cellar: :any,                 monterey:       "b3ac7986c12826bbdc6e9eb512d2edcc26ae53ddd1e977e1d97c9dc28dbd0054"
    sha256 cellar: :any,                 big_sur:        "c72bd1ef2c9ea4d6bc68809ee29536b9044243a3f48d682eab784b3919e66505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9c322a9fb4658e1c0d97bb3c53ea0dbd4be116d66ea4c8e12f3bc214e76c01"
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
