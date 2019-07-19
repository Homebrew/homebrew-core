class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.11/mpg123-1.25.11.tar.bz2"
  sha256 "df063307faa27c7d9efe63d2139b1564cfc7cdbb7c6f449c89ef8faabfa0eab2"

  bottle do
    sha256 "e5a794aa5c9b33a9cc6cc985013268719978d1d2976e537f5c347794fcd0ac6b" => :mojave
    sha256 "4c8734d8990b9a06ef8e8df1e18e4b7015471eaaad5f148ffed507e8bd97ced8" => :high_sierra
    sha256 "c9e01c6baf093b40c30eb056a888e90886668544ae3df6fa08176109c16677dd" => :sierra
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
