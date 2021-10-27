class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.29.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.29.2/mpg123-1.29.2.tar.bz2"
  sha256 "9071214ebdfc1b6ed0c0a85d530010bbb8ebc044cfe5ae5930e83f7e6b7937e6"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "54b1b392f918afaeb2df2f1ce13c9abf5e4dc528e568d8d28b24051e9252008f"
    sha256 arm64_big_sur:  "3e76fd6c5d5120b8843fa476e5a0419049fd2634f93922e20000e8a329b5ba4c"
    sha256 monterey:       "a9615c6c68bc863c9cda5d47a1811c836e4ecbc95c5df06fd38d14fecdaa17fe"
    sha256 big_sur:        "d150ae218a033af966ded545cc5e1381505ab8f38abc6f77b1ef652c007f5dc9"
    sha256 catalina:       "e44e5727e3f794056d55794abb4b58c9045462330b0b9a6550a875291211b997"
    sha256 x86_64_linux:   "5286708d43f21dce89bc03697034933c2fcffbb1a4284f49baa8668d8ab0282f"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
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
