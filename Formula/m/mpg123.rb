class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.5.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.5/mpg123-1.32.5.tar.bz2"
  sha256 "af908cdf6cdb6544b97bc706a799f79894e69468af5881bf454a0ebb9171ed63"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2fe489561b01ae7e46f02a44723675cc9711c0abb42d6a4f585103fc21608918"
    sha256 arm64_ventura:  "5ec4d0fc902cc0a136deaa2c5ceebef45f7b6165bfc37e97a76a94110d5c6461"
    sha256 arm64_monterey: "d7be76a7c86e30dba7b9fc36335ba437e8b73812c7fbaa696b7077b0fdba2a8c"
    sha256 sonoma:         "b4e0e41ad0873074eddd5ee8838674609e681a819118f1bbd75815b7618d1e0a"
    sha256 ventura:        "66c573e30b50e608985d23a6b5e0b3eed924a924b0f8d2a10f737bc55b40235e"
    sha256 monterey:       "f05a188f8ba85077df87d9c154539992c436375d0724165eeb5972cb32794221"
    sha256 x86_64_linux:   "043b1240ba5d1ee43c28a8d19cc8d8628095243554f1df0d5e4bd114e2f36d06"
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
