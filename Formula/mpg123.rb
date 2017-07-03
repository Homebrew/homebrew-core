class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.25.1.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.25.1.tar.bz2"
  sha256 "0fe7270a4071367f97a7c1fb45fb2ef3cfef73509c205124e080ea569217b05f"

  bottle do
    sha256 "3bd78d5a840d679e8685a9ddbf85364e193b92b62d6f98b8cec31bc8baab686b" => :sierra
    sha256 "23ff6e524f6f1f5f401d5c6a407c811b93d69be5d8ccdc1188bdd1a404be6e02" => :el_capitan
    sha256 "cabb97e3808e12c440e3ab5c399338b7fce1e20fd84063270e6e2322273e72de" => :yosemite
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
