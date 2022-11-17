class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/v4.1.1.tar.gz"
  sha256 "66b1b8d6b55d263f35f27f55acaaa3234df2a401232de99b6d099e2bb0a9d196"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84786f756b3c8abf87ed9b2f00649fe9cba1306b1d750cf7dda85e6c6537e3b4"
    sha256 cellar: :any,                 arm64_monterey: "2598e442d31d6010e5e33f8738998face395bbdc94395e822b223413216472b9"
    sha256 cellar: :any,                 arm64_big_sur:  "cb97308fb31faf292fd3b3fd45e5dbcd22cc042f60c72137693ad13ee0e94196"
    sha256 cellar: :any,                 ventura:        "1a2bdb02a4b0aaafc215988a700da5bae238b4a399e86f60210e93868300ca8a"
    sha256 cellar: :any,                 monterey:       "a10111cdb7857b21f956602ab4ede36e4ed34da3823bdf1fdd88d4e3c3a777cf"
    sha256 cellar: :any,                 big_sur:        "f59fa9d539034c511dcc3571cd8f42fbee5c20a0b54947b5be3e3471237b5f15"
    sha256 cellar: :any,                 catalina:       "486e8d49fd85a744ae85acdd29c4d321045aba766c3cf59f5b34e34bb30caa4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42dbdf5129e01632d525b67b70c6d98c4885d6a969dcf3cdaf1a9a56c5834fee"
  end

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
      system "cmake", "..", *args, "-DCMAKE_INSTALL_LIBDIR=#{lib}"
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
