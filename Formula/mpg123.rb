class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.8/mpg123-1.25.8.tar.bz2"
  sha256 "79da51efae011814491f07c95cb5e46de0476aca7a0bf240ba61cfc27af8499b"

  bottle do
    sha256 "504fd8cf5e425bdc7844e3bb6b2422ca92cf8cda6de499950e98ab4efd83a38a" => :high_sierra
    sha256 "f7cef09669aebedec24cdd11bc9462b43a9375b4bfdbf94e4cdaf3bb096b756f" => :sierra
    sha256 "35a5a21e1e77e166a8bbdda086d42655412f6bb94bb25c365ff4f519780bb187" => :el_capitan
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
