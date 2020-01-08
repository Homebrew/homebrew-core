class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.4/libjpeg-turbo-2.0.4.tar.gz"
  sha256 "33dd8547efd5543639e890efbf2ef52d5a21df81faf41bb940657af916a23406"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 "9e99da7951aacca885be09047b17504931d714e980c0f6c6c80e1255feb83f4a" => :catalina
    sha256 "0a069b4a7a45f49f35ec4e2d0f0a4745df6d20cbdbc5f30d68cec32d32702bb0" => :mojave
    sha256 "1a702773d1cfcc71ef75f80b1b14e0b4903da65e462a5e52361c2a2988f05764" => :high_sierra
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
