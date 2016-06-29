class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.23.5.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.23.5.tar.bz2"
  sha256 "b658df672813511ff9b68a1553917220b675067204cdb58dbb59a2b8179350b2"

  bottle do
    cellar :any
    sha256 "73b263481485a4c89d9ec088087d84fe193a1b1d0d4a5d454841dd958ef268cf" => :el_capitan
    sha256 "d5af0c34be1709c5de0778ed6e0694050c2d4c0babe7673edd5ec29a8364f043" => :yosemite
    sha256 "12fbd68462b7bfa9745e26305397789a29105ba860cc58eaa53d29f3f3197442" => :mavericks
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-default-audio=coreaudio",
            "--with-module-suffix=.so"]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mpg123", test_fixtures("test.mp3")
  end
end
