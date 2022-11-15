class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.4/libjpeg-turbo-2.1.4.tar.gz"
  sha256 "d3ed26a1131a13686dfca4935e520eb7c90ae76fbc45d98bb50a8dc86230342b"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "692e1da07f1d20df3d8157bee3b15c37d53fdd04b6d5de754f0841a3915ab1ab"
    sha256 cellar: :any,                 arm64_monterey: "c9dbfe3df4b1c8cd4ac7ef18a3643c923c8081e6acdf9936ebff79b7514f14cd"
    sha256 cellar: :any,                 arm64_big_sur:  "02e7859fbd2d7ac8336600bde67184ff78339146da99525b404ba683d184dff7"
    sha256 cellar: :any,                 ventura:        "4aeb72103a5a6572f7a7574b459ca1d941579c4e9cd93f8c48b7ef208533df09"
    sha256 cellar: :any,                 monterey:       "d2d17e1b59fd7aff903b1b6d15209aa304de4bf974881c11700600f0d7bd486a"
    sha256 cellar: :any,                 big_sur:        "c2cbe03545e80c2b438a3d7f9b96fbcb7db4130b39ddae267a3b199f58f99c1c"
    sha256 cellar: :any,                 catalina:       "8b3fc1875533efe903b131b285074e745c7cbd5888eaec72407a2e1b8a8d150b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda8e2acfdedd64381f39301191955822d082c8c9c65a2dd4b9cece33267408c"
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
