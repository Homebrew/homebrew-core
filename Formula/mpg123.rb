class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.29.3.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.29.3/mpg123-1.29.3.tar.bz2"
  sha256 "963885d8cc77262f28b77187c7d189e32195e64244de2530b798ddf32183e847"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "410a17bf261c1cfd1ab2b483e23089c064f0af68bf9ed9c2b306957a4e17a891"
    sha256 arm64_big_sur:  "234c152f76e232af3a07f6d8b5e4b6f83992b3ed447697c8668b149283e3491c"
    sha256 monterey:       "c51f30de376449bc6f521aa2bb6a41ee20267a45f244878896f36dd9f7ed91d2"
    sha256 big_sur:        "daecddec9c463a10834b412e0c6c58480f3b1465a810e2343beeaf5a67535b69"
    sha256 catalina:       "4dc52f5698a35d5670828ab96bc9de5c910e850c9c20334a5061741b8623de2b"
    sha256 x86_64_linux:   "1843ee9e56f69467b52bd9ce513fd7e73ac76f9836920e1c4732207d7debf2e5"
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
