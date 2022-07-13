class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.30.1.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.30.1/mpg123-1.30.1.tar.bz2"
  sha256 "1b20c9c751bea9be556749bd7f97cf580f52ed11f2540756e9af26ae036e4c59"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b5ffa7483943374e541196f49f916c27c0072a2d61916f23d2f9640a0f4d0ca2"
    sha256 arm64_big_sur:  "2476480ffab1cabc11b4e1b57cc5c8eca00e230ba7c2bfc08fb7626ffd4a778c"
    sha256 monterey:       "c0b1ebce94cce21c2d749816887057e2de8412b2171659f05773d04cb397f7fa"
    sha256 big_sur:        "d3e3dde4066df85a2c74f404862c603700cda285acf93910f8fd9c292937a264"
    sha256 catalina:       "e281b083675b32497ac391908827f34fc8ee49451ae5ad38afcf54e150c8a733"
    sha256 x86_64_linux:   "6cefea56e6e36615c36c715c210a7fa970635a040e4bf534f292d6f0868a53eb"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

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
