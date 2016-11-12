class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.23.8.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.23.8.tar.bz2"
  sha256 "de2303c8ecb65593e39815c0a2f2f2d91f708c43b85a55fdd1934c82e677cf8e"

  bottle do
    cellar :any
    sha256 "5c51c790ee62d7a1520c8c81a96ce5176d3d16b08cb6c03c1a269b2360e4a4df" => :sierra
    sha256 "bdf3414a597053ca410a5fcecf26b83db90f5af841016b20a4d7346c97ef5632" => :el_capitan
    sha256 "35ce9d91de57ed29a6e97212fc106af5c3d3f73797133889d18d091137ec3443" => :yosemite
    sha256 "d7951ac7646e779ba5a2c7a35bc48a788e1b4e435480d9e2aeef858ca27835fa" => :mavericks
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
