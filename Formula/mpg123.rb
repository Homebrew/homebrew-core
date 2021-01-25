class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.26.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.4/mpg123-1.26.4.tar.bz2"
  sha256 "081991540df7a666b29049ad870f293cfa28863b36488ab4d58ceaa7b5846454"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "2ebc5eab8199c9cc750504cde6f6fe739ba596f5129b59c79d51fb0d4d54b113" => :big_sur
    sha256 "0bc1e129314c8f53f34ff804b6cb868ead8e223fe74e11fbef4ffcc969c2771e" => :arm64_big_sur
    sha256 "0b9132c429c02b726597beeb217ce2f69ba63e1edf6bbff96652e080ba6f10a7" => :catalina
    sha256 "5027b3751482e62a72c8a5514c728ae8ae1f4aaf34c46a9264a64fc11883c16b" => :mojave
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
    ]

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
