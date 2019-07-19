class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.11/mpg123-1.25.11.tar.bz2"
  sha256 "df063307faa27c7d9efe63d2139b1564cfc7cdbb7c6f449c89ef8faabfa0eab2"

  bottle do
    sha256 "293d4702bee5702d5b75983d2537ea55fcc751f95b19883f69ad1aa105062fe4" => :mojave
    sha256 "ddcbdf62b3ddf3ad7d1b73f76aca1c51c4ba7bc85484b0d04050dfe7bb3f8a68" => :high_sierra
    sha256 "86afb9e31472b3b4b432bbad04b8e88d7f60b7a35c14208a4c0313ef4beb7b97" => :sierra
    sha256 "079e45cffa682e9cbdc42a51a4d7362e28246311e9f6268e246d255b3dfc0cc9" => :el_capitan
  end

  def install
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
