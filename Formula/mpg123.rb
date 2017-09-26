class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.7/mpg123-1.25.7.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.7.tar.bz2"
  sha256 "31b15ebcf26111b874732e07c8e60de5053ee555eea15fb70c657a4f9f0344f3"

  bottle do
    sha256 "f401a38a4a6d73301dbfebdb1d641fc2edfaad5709cd2fadc169c5e99ef7d80f" => :high_sierra
    sha256 "a9b707bde969e2606b517efc0dc01c56aee32a91aaac131b27351184f24c5659" => :sierra
    sha256 "5650febcb5fc8c64c1ba8054728ef1b4b4d35a9f132a493947e8b011a2376f19" => :el_capitan
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-default-audio=coreaudio
      --with-module-suffix=.so
    ]

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
