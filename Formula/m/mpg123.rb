class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.3/mpg123-1.33.3.tar.bz2"
  sha256 "6a0c6472dd156e213c2068f40115ebbb73978c2d873e66bae2a250e2d2198d26"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "35363664ca62143633c27207668be413ed6fe45140ee7440b0b9e2110dd700e3"
    sha256 arm64_sequoia: "5c0f3a5461e813ea34f0be6623d950687292b734a0aec33e46e54678eb17bf13"
    sha256 arm64_sonoma:  "df1512052024858ea9773d91b8b420dc3e712163e009b56096ed9e7a771555ac"
    sha256 sonoma:        "46d9a3116cf7de6bca9e935fa84486ebec292d532cb202455a217b61809344bf"
    sha256 arm64_linux:   "9a47e6b3e9eb9f77337d1b08cd014ea34c422ead3abb3d14ac6562d78d240073"
    sha256 x86_64_linux:  "80a291a14ebc74921bb418a75a658ca9dbddc52175d11f7cc5b0ced19b5092ec"
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
