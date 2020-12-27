class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.4/mpg123-1.26.4.tar.bz2"
  sha256 "081991540df7a666b29049ad870f293cfa28863b36488ab4d58ceaa7b5846454"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e3e025bc2ecaf9598e5608a19cc3c8cb44d867acecb0193d589800a92d5082bd" => :big_sur
    sha256 "9fe91130d664eab75c1e034ea1f3cb44e90e6212fe978c7e9bb9945e83916b90" => :catalina
    sha256 "fb7123c88bf249dc4841f41dce370dda96d50c7499ab27992442a88fed6b9c3c" => :mojave
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
    ]

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
