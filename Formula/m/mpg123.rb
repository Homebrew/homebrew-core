class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.3/mpg123-1.32.3.tar.bz2"
  sha256 "2d9913a57d4ee8f497a182c6e82582602409782a4fb481e989feebf4435867b4"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6324a30c5b49b4c62882ad10adcce474a3649c466a9557def3ca9dcda10439e6"
    sha256 arm64_ventura:  "f0ec99c74eea1c53a1f567b5c7ddef33b9c606b5af49d9913e49e52e468f859b"
    sha256 arm64_monterey: "fd9b2d9479afcac36e5bf8fc994c84f3dcf5706586a44e9db95bce9a6a45d043"
    sha256 sonoma:         "d5b83bc1af027fde3daedac23dcdb0e16e200938297017b80a07ec7c73ce6674"
    sha256 ventura:        "9058810279d84c616d1ee14a38538712cf25c2ce57d56ebf7dc542c8ae988000"
    sha256 monterey:       "84a62db870ec01c79069eee3d1c77b7fcec72e84d78e79a32ab3c79201ec55d0"
    sha256 x86_64_linux:   "d32e43d1bf8b202c853b0c5d532e475f53e6979c2bf61ad1d214068e88d96f79"
  end

  def install
    args = %w[
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
