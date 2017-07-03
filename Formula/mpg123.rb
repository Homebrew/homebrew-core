class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.25.1.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.25.1.tar.bz2"
  sha256 "0fe7270a4071367f97a7c1fb45fb2ef3cfef73509c205124e080ea569217b05f"

  bottle do
    sha256 "53e98bf1310af7848cf88bb67d85d625e60f1418a61861a5c65d7751c3659591" => :sierra
    sha256 "58c6414620f1d4f5a139ab7355071818478f0f1994a471e6ab0ec2f8d85d95bf" => :el_capitan
    sha256 "641ddef48874cdff2f03c6e2d827df76a8a9b4b5824a394962a7c9c519c5decf" => :yosemite
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
