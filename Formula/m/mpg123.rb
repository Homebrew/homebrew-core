class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.2/mpg123-1.33.2.tar.bz2"
  sha256 "2c54fabbfa696dce8f9b137c8ef7a429a061f8fe633cd7d0a511809855f2c219"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a14888e822298991189c0892c8ebdbc55293c8ae14d8cff7e784db92aeec8844"
    sha256 arm64_sequoia: "ef311cff7f895e6d9833813db551278279d5c9c7ce37635e3fe441c5c8d64928"
    sha256 arm64_sonoma:  "c93bc7d9767870d8b1e63e4f3bf2244f9b3fff0734dcb42f59e73546a73135a8"
    sha256 arm64_ventura: "3180f35b1e5d325a01d911190b9b51a7b7dfe864150a54ef8cdddf023215f2a3"
    sha256 sonoma:        "0ab9586119105d88ce828b499ed2e04c948438a04776fdcaa9c21ce2cc243665"
    sha256 ventura:       "214c094788329bcbeae8f28c1a1be5cc2b9f0968afa0ea3579cebac27512b3a5"
    sha256 arm64_linux:   "826307d951bc5b2f34824cd3e74638b1f1a6dbe21eabe6f9195dbe421b4f614a"
    sha256 x86_64_linux:  "76b17a858267bf11e5f3f1202a2adc8f5f76ab446c98156b46986ac6aa54132e"
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
