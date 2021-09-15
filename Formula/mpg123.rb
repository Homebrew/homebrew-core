class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.29.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.29.0/mpg123-1.29.0.tar.bz2"
  sha256 "135e0172dfb6c7937a81f1188c27f9a47b0a337f7637680039ff3ee5fea3ce7d"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2bdee7fd0a435ee6fbfaeb3b045d9e47508aac20224c763d87076b533e213dd9"
    sha256 big_sur:       "230c0e10a82c7b64faf1b8c68a5974806fd0c5fb05e700629e2dff2270276d63"
    sha256 catalina:      "ee6a701ac1d90feeaf7320674667ada58ae9c0a7d1cf5601e496011a13a3da8e"
    sha256 mojave:        "0b9dd2fcac658e721a6bb764c409e085bd3accacdac223aaf928f42f1acab6ba"
    sha256 x86_64_linux:  "4b1d43c7f072efc93f3445001f9adda4b36cb4fc60d699f53571132699ecdc33"
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
