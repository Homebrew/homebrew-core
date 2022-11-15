class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.31.1.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.31.1/mpg123-1.31.1.tar.bz2"
  sha256 "5dcb0936efd44cb583498b6585845206f002a7b19d5066a2683be361954d955a"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "804cb30f0c5bd0adc90ab5f297ec3f8d78db8adec1c8346808bd48faa54a503c"
    sha256 arm64_monterey: "1cd03ee5a750fe9a6b600c5c3c5f4869ceccbb6fe69043f36c335b7378668775"
    sha256 arm64_big_sur:  "fd6e9184b63d3c5ce015a26e996d5515ac79adc5854d961757fed86b4cdbfee6"
    sha256 ventura:        "88721da6d559fb9b5901fa8bc0cbb07cc73408b7dbd1f35eb18636a310e0a599"
    sha256 monterey:       "8a76894636327da8ada727b1d3462961934bb2f5123eb9361a28e3fc01dbb760"
    sha256 big_sur:        "bd459f73494f65f4c489620ce83fd8dd445fb028b8d6e7a82fcbea05e8547fd9"
    sha256 catalina:       "618b1c831f3e92cce81596738b6a1599343903b0a883fa80cc85ec3d282a76c5"
    sha256 x86_64_linux:   "6b555a1650e90f0480860e5460ee51de2becfff598974f0dbbd491d350889497"
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
