class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.3/mpg123-1.25.3.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.3.tar.bz2"
  mirror "https://mpg123.orgis.org/download/mpg123-1.25.3.tar.bz2"
  sha256 "c24848dd1fcaf6900a2b1f5549996904f75fe6e05de982da655f8c626b375644"

  bottle do
    sha256 "a948000e58f5453b336465d2301c9268aac26f32d6181e3012055d14ed8ef864" => :sierra
    sha256 "708339d1dd99a685aea4d48a648a06746c0f51618518cdd6ddaf4094cbb9d3a4" => :el_capitan
    sha256 "4240c4349208045a3c4bc6c07683a94fbd887ee85ecbe8924739f8d004f7ed63" => :yosemite
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
