class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.30.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.30.2/mpg123-1.30.2.tar.bz2"
  sha256 "c7ea863756bb79daed7cba2942ad3b267a410f26d2dfbd9aaf84451ff28a05d7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4b591ea40988ad60cec49f545d8d16ca5d293bde798eaeeda05293c7538a9a2f"
    sha256 arm64_big_sur:  "807d6194b9a03cf521a000e934d4ad7755b1ff0762a441761c01714d38aeb70d"
    sha256 monterey:       "359d0ef12c2877f61dca8be72cb8abe681fcd0c03ba45091ae065ddef48dc9c7"
    sha256 big_sur:        "cde0f7e476f0b96b343e929ea62c4b45b4290990ad3bae4b25006b67edbd9e07"
    sha256 catalina:       "19bd71f268ede8d39635f9fe7f0a1636965a214c509370b4034a52210aa86f71"
    sha256 x86_64_linux:   "c94544bc4a74b0feac3dc8e087cb43cfaf6573b32581972ecc7877e39694a5aa"
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
