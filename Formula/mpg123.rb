class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.5/mpg123-1.25.5.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.5.tar.bz2"
  sha256 "358da8602c001e6b25dddd496f50540a419e9922f0efe513e890f266135926b1"

  bottle do
    sha256 "cdc3c0e01f2304e65a1e91bf6166c973abe804e0a7722e2a4fc05da5b0d419cd" => :sierra
    sha256 "a0246dd4fbf0875199541784222eda3c26f178f386585d9d1f4be2040c636f1e" => :el_capitan
    sha256 "957d3f24b10dbbfb77af2c0d49662d1aaa96d83ed3b13c6e41a99fa3341f64c3" => :yosemite
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
    ]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
