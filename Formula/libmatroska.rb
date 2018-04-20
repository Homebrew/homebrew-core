class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.9.tar.xz"
  sha256 "38a61dd5d87c070928b5deb3922b63b2b83c09e2e4a10f9393eecb6afa9795c8"

  bottle do
    cellar :any
    sha256 "e4f4d97646cb4860e229532d6a37ac3edeabac4dcc35fb66ff73aa4bd2baad62" => :high_sierra
    sha256 "d9d618b79e33db74df3d594bbb8ce997c7fb3347861ad2ea6e5677cd607a3197" => :sierra
    sha256 "53cffc64b37eec80b8325437f3fd7d84ffdf0626bb87499c1565eaa063c63854" => :el_capitan
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libebml"

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
