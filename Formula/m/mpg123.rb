class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.10.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.10/mpg123-1.32.10.tar.bz2"
  sha256 "87b2c17fe0c979d3ef38eeceff6362b35b28ac8589fbf1854b5be75c9ab6557c"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a7e88250498abc0521be5e43103aa1d411f33ccc08d55bbb37fd34b42015e38e"
    sha256 arm64_sonoma:  "af9d70581ff2cb103d8d4ef92b63ed8e3568687b5a505a145653a50b9277b78f"
    sha256 arm64_ventura: "bc9e0b6ff94df269e8741e8f1ba0234adec63445498f008c93eca30860373188"
    sha256 sonoma:        "8368344c162b5b09a4e270c7bec9bc3356744c32d4375fac5fde9ec09ac366bb"
    sha256 ventura:       "870777a32e3bcdca0eaffde89a3d968b21aba3bae9047c7e36b76ca23a5b7721"
    sha256 arm64_linux:   "7e4c8351af4cc50acf7dc1463483b33e2a3adc8f73a4c51d336137926f07d003"
    sha256 x86_64_linux:  "ceea33a9d7ec86a51a6c26936b253ce738915e344d0e577b628d70065829596a"
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
