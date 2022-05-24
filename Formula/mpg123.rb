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
    rebuild 1
    sha256 arm64_monterey: "10dcbf0526607d93ffb9d8a0723a0798d2474617ad3fd395807700019621635f"
    sha256 arm64_big_sur:  "b6c673ec40d9baff23f7ac20b710d024bd9e4eaa5a72add9a90ba0a24f90998f"
    sha256 monterey:       "c991eb5999e7e68b403c57d855b3dfc3e4932ccc512804339b1c984297b2bf88"
    sha256 big_sur:        "70355cefcf35844d7bf4d7b23b16e1765924d08828acc672f0eb58fbea2bb455"
    sha256 catalina:       "c26284810d5b37211e5a0963095ec22fb07ec3862bb01ba0e87d34cf48a618c8"
    sha256 x86_64_linux:   "56ff29e1333532bc64fba795a3d0d1384ad51fb5fc88557a4db488aad7238d75"
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
