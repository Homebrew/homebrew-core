class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.1.tar.gz"
  sha256 "acfc76ee19b3d41bb9c7e8b780ca55d413893a96c09f3b27bdb9b2573b41fd23"
  revision 2

  bottle do
    sha256 "e132dbc428f2ab5fb85099983b1558954f6bcf71e9acf2c65beb02b4c9cda198" => :sierra
    sha256 "56bef37d2a51e3af48a53c43d6610618c8f75040cb53e7716f3e02e8b15fceea" => :el_capitan
    sha256 "2b1d937bf755a56f048fdf7ea221485e5acd104e595433b8f02e90baf6db979a" => :yosemite
  end

  depends_on "libtiff"
  depends_on "lzlib"
  depends_on "jpeg"
  depends_on "proj"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            "--with-libtiff=#{HOMEBREW_PREFIX}",
            "--with-zlib=#{HOMEBREW_PREFIX}",
            "--with-jpeg=#{HOMEBREW_PREFIX}"]
    system "./configure", *args
    system "make" # Separate steps or install fails
    system "make", "install"
  end
end
