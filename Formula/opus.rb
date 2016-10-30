class Opus < Formula
  desc "Audio codec"
  homepage "https://www.opus-codec.org"
  url "http://downloads.xiph.org/releases/opus/opus-1.1.3.tar.gz"
  sha256 "58b6fe802e7e30182e95d0cde890c0ace40b6f125cffc50635f0ad2eef69b633"

  bottle do
    cellar :any
    sha256 "450f707fe00fde0aa508dbe51c88d886699283cda0619ab653bc28a23de2f7aa" => :sierra
    sha256 "4c924e65b31d4c18c7a45298f50cc5d580bad1e9814768bc2d6bd27f4c947a40" => :el_capitan
    sha256 "4a80cc671870a8ec595651d450a8e1e624220a1749433a6ad1e3da4f7bb609cb" => :yosemite
    sha256 "b81848495063b300f11b98eb13f9c40f725f6fe78f1fd2549377d2ccc0c3207f" => :mavericks
  end

  head do
    url "https://git.xiph.org/opus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-custom-modes", "Enable custom-modes for opus see https://www.opus-codec.org/docs/opus_api-1.1.3/group__opus__custom.html"

  def install
    args = ["--disable-dependency-tracking", "--disable-doc", "--prefix=#{prefix}"]
    args << "--enable-custom-modes" if build.with? "custom-modes"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end
end
