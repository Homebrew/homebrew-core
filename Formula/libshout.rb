class Libshout < Formula
  desc "Data and connectivity library for the icecast server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/libshout/libshout-2.4.1.tar.gz"
  sha256 "f3acb8dec26f2dbf6df778888e0e429a4ce9378a9d461b02a7ccbf2991bbf24d"

  bottle do
    cellar :any
    sha256 "b254dda56481a6386d7356b1de2d65c094501f4c39d6f44c88282af095a85594" => :mojave
    sha256 "31b3490184bacfbacc6a537385f7ebc421ae750cd2e466f00d53dc9f78ebf948" => :high_sierra
    sha256 "a13a78cf64be826de47b9bc0430ead7ac900fa513be146ad408370d412ce3bce" => :sierra
    sha256 "691763e02e7e63b03d2d530447798351ab92d705fb1fd68cc90f9a5ccd131d53" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "theora"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
