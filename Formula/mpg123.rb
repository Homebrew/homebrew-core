class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.12/mpg123-1.25.12.tar.bz2"
  sha256 "1ffec7c9683dfb86ea9040d6a53d6ea819ecdda215df347f79def08f1fe731d1"

  bottle do
    rebuild 1
    sha256 "4e7eb4254949eee9a6da8f931c5752dab58faecc468ece126d42d0cc6f923a98" => :catalina
    sha256 "80e6dffee72a4f3537f71851c9c74f2a95e5a79a22ac708273c51843418655de" => :mojave
    sha256 "3ac95fd32b8e60ab3e8980fc968b00d3e910fcc0832b2fd2c4a560b7be1b083a" => :high_sierra
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
