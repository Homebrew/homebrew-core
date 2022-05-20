class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.3/libjpeg-turbo-2.1.3.tar.gz"
  sha256 "467b310903832b033fe56cd37720d1b73a6a3bd0171dbf6ff0b620385f4f76d0"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0fe5fd23465784fe56f97c29589a72eacc21f8fb75f8c84e69da724637aee262"
    sha256 cellar: :any,                 arm64_big_sur:  "e47a04f605090bfa71f2bbc71c84ea4f2a0c3986ccc8f61859b31247ed0e9e08"
    sha256 cellar: :any,                 monterey:       "1ee0a0cfd7ceeae5b1bcccc105d47ba9adbf74e53eccde118b4849b654a9cdb9"
    sha256 cellar: :any,                 big_sur:        "14c6fdc80b47eef6b88114cad94f0b311d8d2766dae25ba2660797ccaaa1f4da"
    sha256 cellar: :any,                 catalina:       "54b3b74ffd0af4ee85a3984af36f8cce5be166a2dd74488e64f266716fcfb5d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc674d48947c45d2018420a3e0eb4ae4d0778984ad5a478e165498cafe9b118"
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
