class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.25.0.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.25.0.tar.bz2"
  sha256 "552e3e1db045e00f474252917007795ac295863fc8b13891859b3382d2f24e48"

  bottle do
    cellar :any
    sha256 "f2781679463e9da849fe9fd73f57383b5d53380c1b71b600a9595b99ad28f3f1" => :sierra
    sha256 "82b93955b350286f89f40bce0155495a5583b80ddf2fd87a90eddb673de82b94" => :el_capitan
    sha256 "8d6d266e0963a9f93d28e653da6b60fe9663af9dd49560d36f7b14731a158a65" => :yosemite
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
