class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "http://www.libdmtx.org"
  url "https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/dmtx-utils-0.7.4.zip"
  sha256 "4e8be16972320a64351ab8d57f3a65873a1c35135666a9ce5fd574b8dc52078f"
  revision 2

  bottle do
    cellar :any
    sha256 "212af24923f1fde3dc8b4e9449a15a6fc3f38469a9137b3cf441e4d61be57ffb" => :sierra
    sha256 "9142ebe512b150d127981335a175289c0425af35fab4c3d21d76a543a934afa4" => :el_capitan
    sha256 "a1bcec0ea701b4688e661eee9cf9cfd6ce880a91b160232a1422ecf55c897838" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libdmtx"
  depends_on "imagemagick"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
