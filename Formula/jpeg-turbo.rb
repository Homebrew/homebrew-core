class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.2/libjpeg-turbo-2.1.2.tar.gz"
  sha256 "09b96cb8cbff9ea556a9c2d173485fd19488844d55276ed4f42240e1e2073ce5"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ebc3311796e243227d153577d2ec65957c882eeb09a6741fc1aff4d5c0e399b6"
    sha256 cellar: :any,                 arm64_big_sur:  "8d183051b393578efe9feb7eae93a7d5e71ad46a8231a8b48b5e0493e399795d"
    sha256 cellar: :any,                 monterey:       "3dbb1191dc1373ffb88f1a5b97274868fcfa69148f735423cdfad5f4a36d1390"
    sha256 cellar: :any,                 big_sur:        "b3a110f4ca12fc978472810a4472048b6ba9e4334e9840be9db697836231ea50"
    sha256 cellar: :any,                 catalina:       "4eeef3656699e91a32ad877dd2f6fe927807942b4d1430cccf5b18e357754b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28fb1681a204b7f4a052308606e7ae3f232dcac37eb89e53f8fca31e5a451096"
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
