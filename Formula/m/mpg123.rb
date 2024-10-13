class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.7.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.7/mpg123-1.32.7.tar.bz2"
  sha256 "3c8919243707951cac0e3c39bbf28653bcaffc43c98ff16801a27350db8f0f21"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "bdfbcf046e9b786d1942d516a8fa4a75651454aef959b0d2b02a01f3c2863ee8"
    sha256 arm64_sonoma:   "5bbad58b97fa3ac74819960781bc299b10157ab61532d25f938980a29865a021"
    sha256 arm64_ventura:  "7aa123d7bad37b4163d27fcf6f2497fccd94aa179e9c08db83f64b39da58a3bb"
    sha256 arm64_monterey: "5bca2db8909eb3674430b04bb513cbfb32ef999bfe3c9cc138975d0ead4d1dee"
    sha256 sonoma:         "ec7b7c96469c21586f4dedfd8a7c70d88f76ee8332df6da6cb0ce972b7b25874"
    sha256 ventura:        "002609858e4800e9c34ff7ef6c4dd679a0d3e977a8d2acabc8e9570115b7ac2c"
    sha256 monterey:       "ace85b1a94cb3057666a7a88ef8805d56c3dadccb5254539cc7a786d7e8228c6"
    sha256 x86_64_linux:   "98cce11ffd6520c9de0e4be4b4d92aa80dcc4a60a6dd189c4aa309b75de2cb71"
  end

  def install
    args = %w[
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
