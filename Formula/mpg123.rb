class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.29.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.29.2/mpg123-1.29.2.tar.bz2"
  sha256 "9071214ebdfc1b6ed0c0a85d530010bbb8ebc044cfe5ae5930e83f7e6b7937e6"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d6916d4bc5a6e4c30bade9cb53f4d3e3fae039796fcf3e22c88c518d043aff6a"
    sha256 arm64_big_sur:  "2bdee7fd0a435ee6fbfaeb3b045d9e47508aac20224c763d87076b533e213dd9"
    sha256 monterey:       "c4be8443662544bf60c8886a21f110cfad08920b22d6e393f9734d27fe190f30"
    sha256 big_sur:        "230c0e10a82c7b64faf1b8c68a5974806fd0c5fb05e700629e2dff2270276d63"
    sha256 catalina:       "ee6a701ac1d90feeaf7320674667ada58ae9c0a7d1cf5601e496011a13a3da8e"
    sha256 mojave:         "0b9dd2fcac658e721a6bb764c409e085bd3accacdac223aaf928f42f1acab6ba"
    sha256 x86_64_linux:   "4b1d43c7f072efc93f3445001f9adda4b36cb4fc60d699f53571132699ecdc33"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
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
