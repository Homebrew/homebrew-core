class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.31.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.31.3/mpg123-1.31.3.tar.bz2"
  sha256 "1ca77d3a69a5ff845b7a0536f783fee554e1041139a6b978f6afe14f5814ad1a"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2f75c25aa671823c45ec2b4b316da18cd49b63efe29f4b7a2e3ebb820aeb673f"
    sha256 arm64_monterey: "692cef43a4b878816002a5eec1d3c01beed6b08083d429da44cc4cdf6568ff9e"
    sha256 arm64_big_sur:  "c5fb9542af5abdb02c932fbc19ba30d88dc2b8934d2e9cf4293171966cee71df"
    sha256 ventura:        "a9b26c05235221b760d960290de3946e320513a56f4a6b940e0dbd6f227ce73c"
    sha256 monterey:       "8363ac5eca09102a525f9fa1c0edc930beb3e216377cd14667f4dc9d33ff3d83"
    sha256 big_sur:        "d8e4370e7a3027d9200d8648e8b4e7926d22e07110e018bbcf17e9de3af015ca"
    sha256 x86_64_linux:   "f7a58a2c6a6a209c08bedfd6d9f11ccf770baefbe6b7779d16d379b4df02328d"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
