class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.23.6.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.23.6.tar.bz2"
  sha256 "4073d9c60a43872f6f5a3a322f5ea21ab7f0869d2ed25e79c3eb8521fa3c32d4"

  bottle do
    cellar :any
    sha256 "553c1e6655bcccc3a81e9f237ceebf20cd5b486aeaaaeba232aed1ab6d2c6567" => :el_capitan
    sha256 "7eedbb4db0591d8fbcb8e8f9a026588a08ddc570d041eff2adc4ac32dbbfb5d7" => :yosemite
    sha256 "2a4269d006f6d23f8b800e1b61fd5474a91f515a6b723a48bcda408286cc3462" => :mavericks
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
    system bin/"mpg123", test_fixtures("test.mp3")
  end
end
