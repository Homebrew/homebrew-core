class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.5/mpg123-1.25.5.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.5.tar.bz2"
  sha256 "358da8602c001e6b25dddd496f50540a419e9922f0efe513e890f266135926b1"

  bottle do
    sha256 "410bd72a44b4009be2e422bd033a89d4f5476bb3ecd618cc60ab52cb0948c530" => :sierra
    sha256 "72e6bcb622dc61d07c2867e4eda38db99619ab96b7febd0708ff1537ffdd2357" => :el_capitan
    sha256 "aed10a2e8ad91d3f6a0c00c6ddc7d0034e8f26149e4e747b8ceb3aece390c578" => :yosemite
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
