class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/2.1.1/libjpeg-turbo-2.1.1.tar.gz"
  sha256 "b76aaedefb71ba882cbad4e9275b30c2ae493e3195be0a099425b5c6b99bd510"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f161380b8c804bcfe7471afa6b4f5c8c7ec2c1ce5afb8c124ab9a51c26d18fb6"
    sha256 cellar: :any,                 big_sur:       "9651b9878e835689171e01acb7873d0a206b3584fa5fb533560f3ece42d86ed3"
    sha256 cellar: :any,                 catalina:      "f5e38eb0033ecf19ceea50b6fd6fd88d5249ae3db71c74d5afc89cefc6fa105d"
    sha256 cellar: :any,                 mojave:        "45548ea854ed61ff928881829797cc091c455adec26eca2f6922286b475196a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e39ae4071b284eb65e582ce697e3c5d6d77e3fda68839c96127d51f857b63f"
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
