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
    sha256 arm64_ventura:  "28c36a95aa73e8168cd267e17c00b7461afe9f72470b5a5f2ad4270cffe54d6c"
    sha256 arm64_monterey: "f23ff202265261d8fa26e2d0f75cbdc37983e4db907730fb9b881d07426bc143"
    sha256 arm64_big_sur:  "93f95c194f36a8e70f8b8481643d3f01c670c1467852d61a5759f83c26ddceb6"
    sha256 ventura:        "62bdc19ab0fb45a6e5c9043ccdb403b042a29d72416a6de777c65a1937b82967"
    sha256 monterey:       "c019bd4a86883f358388511ba013eb88c52017f1ce81321941904e73ab410887"
    sha256 big_sur:        "2239b5414a9a80c44ebf39ede0304619a1a3fbaa5feca7b37df68a629f619b23"
    sha256 x86_64_linux:   "f6f378ab7a10bf6e14832c270962adb7eb2e18fd80f35535d49201dce842d54b"
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
