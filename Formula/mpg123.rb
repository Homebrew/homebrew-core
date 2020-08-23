class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.3/mpg123-1.26.3.tar.bz2"
  sha256 "30c998785a898f2846deefc4d17d6e4683a5a550b7eacf6ea506e30a7a736c6e"

  bottle do
    sha256 "95a40afc24b7ab30eff21a988421d9b172f5b073fe3291cf01db8b42531f5ca4" => :catalina
    sha256 "9b4f0e5aa8a80ff30ffa01c4076f76112d7252015416c5b58a7e5b4a5862d786" => :mojave
    sha256 "426a0e2c5650cd89be77a3aa78f8ebcb7bd5a2fd220675dc58c630be0ab0ec15" => :high_sierra
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
