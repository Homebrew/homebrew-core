class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.0/libjpeg-turbo-2.0.0.tar.gz"
  sha256 "778876105d0d316203c928fd2a0374c8c01f755d0a00b12a1c8934aeccff8868"

  bottle do
    cellar :any
    sha256 "f40b0fe6a775f787436bace3e201c0cd9b441fe24c64093c948ddc369e94b0fd" => :high_sierra
    sha256 "0a499d6cc6e1de389154fb0d859fe2def77a973c629125ac8c783cb872e055db" => :sierra
    sha256 "6912770fdaefa0941c3259cbec3abf670ba8b6067239fde276686ed610599dda" => :el_capitan
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "cmake" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
