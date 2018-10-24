class Mscgen < Formula
  desc "Parses Message Sequence Chart descriptions and produces images"
  homepage "http://www.mcternan.me.uk/mscgen/"
  url "http://www.mcternan.me.uk/mscgen/software/mscgen-src-0.20.tar.gz"
  sha256 "3c3481ae0599e1c2d30b7ed54ab45249127533ab2f20e768a0ae58d8551ddc23"
  revision 3

  bottle do
    cellar :any
    sha256 "7c8d0297e12d8f8fe310803f60ccc2df5a53a44a2dcb859e8db3fc9772532ae8" => :mojave
    sha256 "eef016c2ae4578d56e945ce6aa84b217db47dfd3165f04a9a406f5a07b6c9bed" => :high_sierra
    sha256 "a81b0ee37f11f69e72fdde3e30bb789c738027b9e0c82be1ab21467623f66b66" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gd"
  depends_on :x11 => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
