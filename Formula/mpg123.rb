class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.7/mpg123-1.25.7.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.7.tar.bz2"
  sha256 "31b15ebcf26111b874732e07c8e60de5053ee555eea15fb70c657a4f9f0344f3"

  bottle do
    sha256 "30f75399cef23bd8dc659f776e32c8fe5714e6bca00858e597557c27aecf7a25" => :high_sierra
    sha256 "a6f996f5ce5bccf8fba568fe10489e4574d81599e90c6cdae036a373a453fdd2" => :sierra
    sha256 "1a6e13ae5c41967f3888100c206c88f255163b20aec5bf3c8f43db23a70d5e96" => :el_capitan
    sha256 "0077d48101b213dd32503b0edc84efb730d5d00f6c3ca9ee77b4d4c133c16b4e" => :yosemite
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
