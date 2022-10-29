class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.31.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.31.0/mpg123-1.31.0.tar.bz2"
  sha256 "481bc0dd78904b28d7f8df7456603a71bdcbc7140716c0c3ec8a1a6635f58c81"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "576d771918cf0a4e086055c80e9c5e07924dff981776184e00fbb37e48be6fae"
    sha256 arm64_big_sur:  "a5783a165741137b1c0a67d8eb8127ea250f77861b669a7573b91c810254b7a1"
    sha256 monterey:       "0b611e4e928f69ff9044ea5b20f550c8bf2cf49f0112c2c3161446c0242c1f0a"
    sha256 big_sur:        "5048c490cd146af934a475678f2b191e17e7b806fb4e3c03727ba65684f9bc27"
    sha256 catalina:       "ec1a2976cbcb4f26f6ffa9d7544af8199add047890776a772d4db7a946eb3a5b"
    sha256 x86_64_linux:   "c0ca9fdec95b505d6a4d8eaf93523e31aa2187120c4930b10695a6ebd79bbfc8"
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
