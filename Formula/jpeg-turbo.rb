class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.0.5/libjpeg-turbo-2.0.5.tar.gz"
  sha256 "16f8f6f2715b3a38ab562a84357c793dd56ae9899ce130563c72cd93d8357b5d"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 "8e5ea85c9b9e2c35badbae2ac326871779438d92d89caedf4a454ae31699c65f" => :catalina
    sha256 "705f3e434a0e2d28360ae63fe99cca55b552bee2e95eac737a49b825946b91dd" => :mojave
    sha256 "4d564fd7620edb99c656a964cdd53aeb3c93d9f61ff1a94c68bf568cce789f67" => :high_sierra
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
