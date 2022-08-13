class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.30.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.30.2/mpg123-1.30.2.tar.bz2"
  sha256 "c7ea863756bb79daed7cba2942ad3b267a410f26d2dfbd9aaf84451ff28a05d7"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d71da0632cdba1d3598772f244d792a2ab4962070097b16d61e1c0c0573ae163"
    sha256 arm64_big_sur:  "fbff9273dd2c45330edcfcf1ec0ddf5f5b33da0566674c5cc91b0e23eb9f1096"
    sha256 monterey:       "80e4eee2600339433292ec488698edc3b90471558d06b36549b56800c70bfe76"
    sha256 big_sur:        "567cbfd37c899a29e1e437ddbe7845432690d5dcc2cdc7eed7b712b628fd4563"
    sha256 catalina:       "0e46a112ea2f18ded17acfbefd30e9857426d4dd88652193d8cea866e8f9ea9b"
    sha256 x86_64_linux:   "ce20ec291724c55c8c38e34be4ea37dc83e817011046f2c63d5cbb3a8c0188f4"
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
