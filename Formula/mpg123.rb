class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.3/mpg123-1.26.3.tar.bz2"
  sha256 "30c998785a898f2846deefc4d17d6e4683a5a550b7eacf6ea506e30a7a736c6e"

  bottle do
    sha256 "29e4e2b5e306f94d2ce0e900f8413b4751f5df28488a476558527119b09bf015" => :catalina
    sha256 "9e80680b18a8b2e000d32aee02c5b5b03e95d617119d1a922a1ac48da4df66f6" => :mojave
    sha256 "6a9d7414515325f52473be05e484faa1c314ffb65582588d9c312400d3e9d6bd" => :high_sierra
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
